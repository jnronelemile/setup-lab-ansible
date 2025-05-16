!/bin/bash
# Script to automate the setup of an Ansible lab using Alpine Linux 3.20.3

# Variables
ALPINE_VERSION="3.20.3"
# Variables
CONTROL_NODE=$(hostname)
MANAGED_NODE="ip172-18-0-37-d0jm7o291nsg00eq3fe0@direct.labs.play-with-docker.com"
INVENTORY="inventory.ini"

# Install necessary packages on Alpine Linux
echo "Installing Python3, pip, Nano and Ansible..."
apk update && apk upgrade
apk add python3 py3-pip ansible nano bash

# Générer une clé SSH (sans mot de passe pour simplifier)
ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa

# Afficher la clé publique (à copier dans les nœuds gérés)
cat ~/.ssh/id_rsa.pub

ssh ip172-18-0-51-d0jm7o291nsg00eq3fe0@direct.labs.play-with-docker.com