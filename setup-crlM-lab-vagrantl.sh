
#!/bin/bash

set -e  # Stop script si erreur

#Variables
KEY_PATH="$HOME/.ssh/id_ansible"
IP_ADDRESS="192.168.56.11"

echo "1. Génération d'une clé SSH pour Ansible..."
if [ ! -f "${KEY_PATH}" ]; then
  ssh-keygen -t ed25519 -f "${KEY_PATH}" -N ""
else
  echo "Clé SSH déjà générée : ${KEY_PATH}"
fi

echo "2. Envoi de la clé publique vers node1 ..."

ssh -i /vagrant/.vagrant/machines/node1/virtualbox/private_key \
    -o StrictHostKeyChecking=no \
    vagrant@${IP_ADDRESS} \
    "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys" < "${KEY_PATH}.pub"

echo "3. Test ping-pong sur le node1"
ansible -i inventory node1 -m ping