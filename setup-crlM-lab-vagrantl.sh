#!/bin/bash



# === VARIABLES ===
KEY_NAME="deploy_key"
KEY_PATH="$HOME/.ssh/${KEY_NAME}"
VM_NAME="web"
VM_IP="192.168.56.11"
VM_USER="vagrant"
TARGET_USER="deploy"
PRIVATE_KEY_PATH="/vagrant/.vagrant/machines/${VM_NAME}/virtualbox/private_key"
INVENTORY_PATH="/home/vagrant/ansible-webstack-boost/inventory"

echo ""
echo "Étape 1 - Installation d'Ansible si nécessaire..."
if ! command -v ansible >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y ansible
else
  echo "Ansible est déjà installé."
fi

echo ""
echo "Étape 2 - Génération de la clé SSH si elle n'existe pas..."
if [ ! -f "${KEY_PATH}" ]; then
  ssh-keygen -t ed25519 -f "${KEY_PATH}" -N ""
else
  echo "Clé déjà existante : ${KEY_PATH}"
fi

echo ""
echo "Étape 3 - Vérification que l'utilisateur '${TARGET_USER}' existe sur le noeud cible..."
ssh -i "$PRIVATE_KEY_PATH" -o StrictHostKeyChecking=no ${VM_USER}@${VM_IP} "
  id ${TARGET_USER} 2>/dev/null || sudo useradd -m -s /bin/bash ${TARGET_USER}
"

echo ""
echo "Étape 4 - Déploiement de la clé publique dans /home/${TARGET_USER}/.ssh/authorized_keys..."
ssh -i "$PRIVATE_KEY_PATH" -o StrictHostKeyChecking=no ${VM_USER}@${VM_IP} "
  sudo mkdir -p /home/${TARGET_USER}/.ssh &&
  sudo bash -c 'cat >> /home/${TARGET_USER}/.ssh/authorized_keys' < ${KEY_PATH}.pub &&
  sudo chown -R ${TARGET_USER}:${TARGET_USER} /home/${TARGET_USER}/.ssh &&
  sudo chmod 700 /home/${TARGET_USER}/.ssh &&
  sudo chmod 600 /home/${TARGET_USER}/.ssh/authorized_keys
"

echo ""
echo "Étape 5 - Test de connexion SSH en tant que '${TARGET_USER}'..."
ssh -i "${KEY_PATH}" -o StrictHostKeyChecking=no ${TARGET_USER}@${VM_IP} "echo 'Connexion SSH OK'"

echo ""
echo "Étape 6 - Test de ping Ansible..."
ansible -i ${INVENTORY_PATH} ${VM_NAME} -m ping

echo ""
echo "Initialisation complète du laboratoire terminée."
