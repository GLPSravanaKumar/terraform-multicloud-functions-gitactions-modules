#!/bin/bash
set -euo pipefail
set -x

# Detect OS
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS="${ID:-unknown}"
  OS_FAMILY="${ID_LIKE:-}${OS}"
else
  echo "Cannot detect OS type"
  exit 1
fi

echo "Detected OS: $OS ($OS_FAMILY)"

COMMON_PACKAGES="unzip wget curl jq"

install_on_debian() {
  sudo apt-get update -y
  sudo apt-get install -y gnupg software-properties-common $COMMON_PACKAGES python3 python3-venv python3-pip

  # Add HashiCorp GPG key (idempotent)
  if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]; then
    wget -qO- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  fi

  # Add repo (idempotent)
  UBUNTU_CODENAME="$(. /etc/os-release && echo "${UBUNTU_CODENAME:-}")"
  if [ -z "$UBUNTU_CODENAME" ]; then
    # fallback to lsb_release if available
    if command -v lsb_release >/dev/null 2>&1; then
      UBUNTU_CODENAME="$(lsb_release -cs)"
    else
      UBUNTU_CODENAME="stable"
    fi
  fi
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${UBUNTU_CODENAME} main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

  sudo apt-get update -y
  sudo apt-get install -y terraform docker.io ansible
}

install_on_rpm() {
  # Use dnf if present otherwise yum
  PM="yum"
  if command -v dnf >/dev/null 2>&1; then
    PM="dnf"
  fi

  sudo ${PM} -y update || true
  # Install basic utils
  sudo ${PM} -y install yum-utils $COMMON_PACKAGES python3 python3-pip || true

  # Add HashiCorp repo (idempotent)
  if [ ! -f /etc/yum.repos.d/hashicorp.repo ]; then
    # Try to create a generic hashicorp.repo compatible with RHEL/CentOS/Amazon Linux
    cat <<'EOF' | sudo tee /etc/yum.repos.d/hashicorp.repo > /dev/null
[hashicorp]
name=HashiCorp Stable - $basearch
baseurl=https://rpm.releases.hashicorp.com/RHEL/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://rpm.releases.hashicorp.com/gpg
EOF
  fi

  # Refresh metadata
  sudo ${PM} makecache || true

  # Install terraform via repo. If not present, try adding repo via yum-config-manager
  if ! sudo ${PM} -y install terraform; then
    if command -v yum-config-manager >/dev/null 2>&1; then
      sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo || true
    fi
    sudo ${PM} -y install terraform || true
  fi

  # Install docker
  # Amazon Linux may use 'docker' or 'docker-ce'. Use package available
  sudo ${PM} -y install docker || sudo ${PM} -y install docker.io || true

  # Try to install ansible via package manager first
  if ! sudo ${PM} -y install ansible; then
    # On RHEL, install EPEL or fallback to pip-based install
    echo "Package 'ansible' not available via ${PM}. Trying pip install (ansible-core + ansible)."
    sudo python3 -m pip install --upgrade pip setuptools wheel
    sudo python3 -m pip install --upgrade "ansible-core>=2.15" ansible
    # ensure ansible-playbook is on PATH (pip usually puts under /usr/local/bin)
    export PATH="$PATH:/usr/local/bin"
  fi
}

# Decide which function to run
# Match common families: debian, ubuntu -> apt; rhel/centos/fedora/amzn/amazon -> rpm
case "${OS_FAMILY,,}:${OS,,}" in
  *debian*:* | *ubuntu*:* | *:ubuntu*)
    install_on_debian
    ;;
  *rhel*:* | *centos*:* | *fedora*:* | *amzn*:* | *amazon*:* | *:rhel* | *:centos*)
    install_on_rpm
    ;;
  *)
    # try a more permissive match: if OS contains 'rhel' or 'centos' or 'amzn' treat as rpm
    if [[ "${OS,,}" =~ rhel|centos|amzn|amazon|fedora ]]; then
      install_on_rpm
    elif [[ "${OS_FAMILY,,}" =~ debian|ubuntu ]]; then
      install_on_debian
    else
      echo "Unsupported OS: ${OS}. Exiting."
      exit 1
    fi
    ;;
esac

# Start & enable docker if installed
if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files | grep -q docker; then
  sudo systemctl enable --now docker || true
fi

# quick sanity checks
echo "terraform: $(command -v terraform || echo 'NOT FOUND')"
echo "ansible: $(command -v ansible || echo 'NOT FOUND')"
echo "ansible-playbook: $(command -v ansible-playbook || echo 'NOT FOUND')"

# Hostname setup (Terraform null_resource count aware)
# count_index should be present in environment by Terraform remote-exec
INDEX=$(( ${count_index:-0} + 1 ))
if [[ "$HOSTNAME" == *"public"* ]]; then
  sudo hostnamectl set-hostname "public-server-${INDEX}"
else
  sudo hostnamectl set-hostname "private-server-${INDEX}"
fi

echo "Bootstrap complete."
