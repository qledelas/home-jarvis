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
apt update
apt install -y ca-certificates curl

echo "[2/5] Ajout de la clé GPG Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "[3/5] Ajout du dépôt Docker..."
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt update

echo "[4/5] Installation de Docker Engine et Docker Compose..."
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[5/5] Activation et démarrage du service Docker..."
systemctl enable docker
systemctl start docker

groupadd docker
usermod -aG docker "lecube"

echo ""
echo "Installation terminée."
echo "Pour utiliser Docker sans sudo, reconnectez-vous"