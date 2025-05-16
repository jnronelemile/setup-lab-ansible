#!/bin/bash

# Script to automate the setup of an Ansible lab using PWD (Alpine Linux 3.20.3)
# https://labs.play-with-docker.com

#ALPINE_VERSION="3.20.3"
#CONTROL_NODE=$(hostname)

# Variables
MANAGED_NODE="ip172-18-0-37-d0jm7o291nsg00eq3fe0@direct.labs.play-with-docker.com"
INVENTORY="inventory.ini"

# Install necessary packages on Alpine Linux
echo "Installing Python3, pip, Nano and Ansible..."

apk update && apk upgrade
apk add python3 py3-pip && apk add ansible && apk add nano 

# Créer l'inventaire
cat > "$INVENTORY" <<EOF
[managed_nodes]
node1 ansible_host=$MANAGED_NODE ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa
EOF

# Tester la connexion
echo "Test de connexion Ansible..."
ansible -i "$INVENTORY" node1 -m ping