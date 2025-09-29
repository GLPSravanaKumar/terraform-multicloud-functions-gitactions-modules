# webserver files & Dockerfile avail in /ansible/frontend/

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 593793035673.dkr.ecr.us-east-1.amazonaws.com
aws ecr describe-repositories --repository-names ansible --region us-east-1 || aws ecr create-repository --repository-name ansible --region us-east-1
docker build -t ansible ansible/frontend/
docker tag ansible:latest 593793035673.dkr.ecr.us-east-1.amazonaws.com/ansible:latest
docker push 593793035673.dkr.ecr.us-east-1.amazonaws.com/ansible:latest

# create iam role and attach below ploicy and attached ec2 instances Readonlyaccess 
*** Iam role policy AmazonEC2ContainerRegistryReadOnly attached to instanceprofile 

# vars
vars:
AWS_REGION: "us-east-1"
AWS_ACCOUNT_ID: "593793035673"
ECR_REPO_HOST: "{{ AWS_ACCOUNT_ID }}.dkr.ecr.{{ AWS_REGION }}.amazonaws.com"
ECR_REPO_URL: "{{ ECR_REPO_HOST }}/{{ REPO_NAME }}"
ECR_IMAGE: "{{ ECR_REPO_URL }}:latest"
REPO_NAME: "ansible"


# Install required dependencies
- name: Install prerequisites
ansible.builtin.apt:
name:
- apt-transport-https
- ca-certificates
- curl
- software-properties-common
- gnupg
- unzip
state: present
update_cache: yes

# Add Docker’s official GPG key
- name: Add Docker GPG key
ansible.builtin.apt_key:
url: https://download.docker.com/linux/ubuntu/gpg
state: present

# Add Docker repository
- name: Add Docker repository
ansible.builtin.apt_repository:
repo: "deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ ansible_distribution_release }} stable"
state: present
filename: docker

# Install Docker engine
- name: Install Docker engine
ansible.builtin.apt:
name:
- docker-ce
- docker-ce-cli
- containerd.io
state: present
update_cache: yes

# Install Docker Compose plugin
- name: Install Docker Compose
ansible.builtin.apt:
name: docker-compose-plugin
state: present

# Reload systemd (fix for socket issues)
- name: Reload systemd daemon
ansible.builtin.systemd:
daemon_reload: yes

# Unmask docker.socket (if masked/corrupted)
- name: Unmask docker.socket
ansible.builtin.systemd:
name: docker.socket
masked: no
enabled: no
state: stopped

# Enable and start Docker
- name: Ensure Docker service is running
ansible.builtin.systemd:
name: docker
state: started
enabled: yes

# Adding User to Docker Group
- name: Add ubuntu user to docker group (optional)
ansible.builtin.user:
name: "{{ ansible_user | default('ubuntu') }}"
groups: docker
append: yes
ignore_errors: true

# Install AWS CLI v2
- name: Install AWS CLI v2
shell: |
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
sudo ./aws/install --update
args:
creates: /usr/local/bin/aws

# Login to AWS ECR
- name: Login to ECR (Docker login)
ansible.builtin.shell: |
aws ecr get-login-password --region {{ AWS_REGION }} | docker login --username AWS \ 
    --password-stdin {{ ECR_REPO_HOST }}

# Pull Docker image from ECR
- name: Pull image from ECR
community.docker.docker_image:
name: "{{ ECR_IMAGE }}"
source: pull

# Run Docker container
- name: Run container
community.docker.docker_container:
name: frontend_web
image: "{{ ECR_IMAGE }}"
state: started
restart_policy: always
published_ports:
- "81:80"

# Verify Docker works
- name: Verify Docker installation
ansible.builtin.command: docker --version
register: docker_version
changed_when: false

- debug:
msg: "Docker installed successfully: {{ docker_version.stdout }}"


##### Netflix Webapp frontend #####

- name: Source code from Netflix
      git:
        repo: "https://github.com/CleverProgrammers/pwj-netflix-clone.git"
        dest: "/var/www/html/"