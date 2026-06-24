#!/usr/bin/env bash
set -euo pipefail

# Installer Docker Engine et Docker Compose sur Debian
# Usage : sudo ./scripts/install-docker-debian.sh

if [[ $(id -u) -ne 0 ]]; then
  echo "Ce script doit être exécuté en tant que root."
  echo "Exemple : sudo ./scripts/install-docker-debian.sh"
  exit 1
fi

echo "[1/5] Mise à jour des paquets..."
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

echo "[2/5] Ajout de la clé GPG Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "[3/5] Ajout du dépôt Docker..."
cat > /etc/apt/sources.list.d/docker.list <<'EOF'
deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable
EOF

apt-get update

echo "[4/5] Installation de Docker Engine et Docker Compose..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[5/5] Activation et démarrage du service Docker..."
systemctl enable docker
systemctl start docker

usermod -aG docker "$SUDO_USER"

echo ""
echo "Installation terminée."
echo "Pour utiliser Docker sans sudo, reconnectez-vous"