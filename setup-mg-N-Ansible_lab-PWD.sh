#!/bin/bash

# Script pour automatiser un  Node Manger sur PWD (Play With Docker) pour un Laboratoire ANSIBLE

# Mettre à jour et installer Python + OpenSSH
apk update && apk upgrade
apk add python3 openssh-server

# Démarrer le service SSH
rc-service sshd start

# Activer SSH au démarrage (optionnel, car temporaire sur PWD)
rc-update add sshd

# Créer un utilisateur pour Ansible (évite d'utiliser root)
adduser -D ansible_user
echo "ansible_user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ansible
passwd -u ansible_user

# Copier la clé publique du Control Node ici
mkdir -p /home/ansible_user/.ssh
echo "ssh-rsa AAAA... (clé publique)" >> /home/ansible_user/.ssh/authorized_keys
chown -R ansible_user:ansible_user /home/ansible_user/.ssh
chmod 700 /home/ansible_user/.ssh
chmod 600 /home/ansible_user/.ssh/authorized_keys