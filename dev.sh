#!/bin/bash
set -e
set -x
# Install dependencies
sudo apt update -y
sudo apt install -y apache2 unzip wget curl gnupg software-properties-common

#add new packages in this and taint the null_resource then do terraform apply
# taint command: powershell -Command "foreach ($i in 0..1) { terraform taint null_resource.configure_server[$i] } terraform apply
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo apt update && sudo apt upgrade -y
INDEX=$1
if [[ "$HOSTNAME" == *"public"* ]]; then
  sudo hostnamectl set-hostname test-public-server-${INDEX}
else
  sudo hostnamectl set-hostname test-private-server-${INDEX}
fi

