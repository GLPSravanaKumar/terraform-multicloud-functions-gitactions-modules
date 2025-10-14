#!/bin/bash
set -euo pipefail
set -x
set -e

# Function to wait for apt lock (Debian/Ubuntu)
wait_for_apt() {
  while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || \
        sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || \
        sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
    echo "Waiting for another apt process to finish..."
    sleep 5
  done
}

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

COMMON_PACKAGES="unzip wget curl jq docker.io"

install_on_debian() {
  wait_for_apt
  sudo apt-get update -y

  
  for pkg in $COMMON_PACKAGES software-properties-common python3 python3-boto3 python3-botocore python3-venv python3-passlib python3-pip ; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
      echo "Installing missing package: $pkg"
      wait_for_apt
      sudo apt-get install -y "$pkg"
    else
      echo "Package $pkg already installed, skipping."
    fi
  done
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install ansible -y
  

  # AWS CLI v2
  if ! command -v aws >/dev/null 2>&1; then
    echo "Installing AWS CLI v2"
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -o awscliv2.zip
    sudo ./aws/install
  else
    echo "AWS CLI already installed, updating..."
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -o awscliv2.zip
    sudo ./aws/install --update
  fi
  sudo rm -rf /home/ubuntu/aws
  sudo rm -rf /home/ubuntu/awscliv2.zip

  # Python boto3/botocore
  if ! pip show boto3 >/dev/null 2>&1; then
    pip install boto3 botocore
  else
    echo "Python boto3/botocore already installed, skipping."
  fi

  # Docker enable/start
  sudo systemctl enable --now docker || true

  # HashiCorp GPG key & repo (idempotent)
  if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]; then
    wget -qO- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  fi

  if [ ! -f /etc/apt/sources.list.d/hashicorp.list ]; then
    UBUNTU_CODENAME="$(lsb_release -cs || echo 'stable')"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${UBUNTU_CODENAME} main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
    wait_for_apt
    sudo apt-get update -y
  fi
}

install_on_rpm() {
  PM="yum"
  if command -v dnf >/dev/null 2>&1; then
    PM="dnf"
  fi

  sudo ${PM} -y update || true
  sudo ${PM} -y install yum-utils $COMMON_PACKAGES python3 python3-pip || true

  # HashiCorp repo
  if [ ! -f /etc/yum.repos.d/hashicorp.repo ]; then
    cat <<'EOF' | sudo tee /etc/yum.repos.d/hashicorp.repo > /dev/null
[hashicorp]
name=HashiCorp Stable - $basearch
baseurl=https://rpm.releases.hashicorp.com/RHEL/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://rpm.releases.hashicorp.com/gpg
EOF
  fi
  sudo ${PM} makecache || true

  # Terraform install
  if ! sudo ${PM} -y install terraform; then
    sudo ${PM} -y install terraform || true
  fi

  sudo add-${PM}-repository --yes --update ppa:ansible/ansible

  # Docker & Ansible
  sudo ${PM} -y install docker || sudo ${PM} -y install docker.io || true
  if ! sudo ${PM} -y install ansible; then
    sudo python3 -m pip install --upgrade pip setuptools wheel
    sudo python3 -m pip install --upgrade "ansible-core>=2.15" ansible
    export PATH="$PATH:/usr/local/bin"
  fi
  sudo rm -rf /home/ubuntu/aws
  sudo rm -rf /home/ubuntu/awscliv2.zip
  sudo systemctl enable --now docker || true
}

# Decide installer
case "${OS_FAMILY,,}:${OS,,}" in
  *debian*:* | *ubuntu*:* | *:ubuntu*)
    install_on_debian
    ;;
  *rhel*:* | *centos*:* | *fedora*:* | *amzn*:* | *amazon*:* | *:rhel* | *:centos*)
    install_on_rpm
    ;;
  *)
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

# Hostname setup for Terraform null_resource
INDEX=$(( ${count_index:-0} + 1 ))
if [[ "$HOSTNAME" == *"public"* ]]; then
  sudo hostnamectl set-hostname "public-server-${INDEX}"
else
  sudo hostnamectl set-hostname "private-server-${INDEX}"
fi

echo "Bootstrap complete."
echo "terraform: $(command -v terraform || echo 'NOT FOUND')"
echo "ansible: $(command -v ansible || echo 'NOT FOUND')"
echo "ansible-playbook: $(command -v ansible-playbook || echo 'NOT FOUND')"
