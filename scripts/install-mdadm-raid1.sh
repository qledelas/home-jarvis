#!/usr/bin/env bash
set -euo pipefail

# Installer mdadm et créer un RAID 1 sur deux disques (avec nettoyage préalable)
# Usage : sudo ./scripts/install-mdadm-raid1.sh /dev/sdb /dev/sdc

if [[ $(id -u) -ne 0 ]]; then
  echo "Ce script doit être exécuté en tant que root."
  echo "Exemple : sudo ./scripts/install-mdadm-raid1.sh /dev/sdb /dev/sdc"
  exit 1
fi

if [[ $# -ne 2 ]]; then
  echo "Usage : sudo ./scripts/install-mdadm-raid1.sh /dev/sdb /dev/sdc"
  exit 1
fi

disk1="$1"
disk2="$2"
raid_device="/dev/md0"
mount_point="/mnt/raid1"
partition1="${disk1}1"
partition2="${disk2}1"

for disk in "$disk1" "$disk2"; do
  if [[ ! -b "$disk" ]]; then
    echo "Erreur : le périphérique $disk n'existe pas ou n'est pas accessible."
    exit 1
  fi
done

if [[ "$disk1" == "$disk2" ]]; then
  echo "Erreur : les deux chemins doivent être différents."
  exit 1
fi

echo "Vous allez réinitialiser et créer un RAID 1 sur :"
echo "  - $disk1"
echo "  - $disk2"
echo "ATTENTION : Tout le contenu actuel de ces disques sera définitivement effacé."
read -r -p "Continuer ? [y/N] " response
case "$response" in
  [yY][eE][sS]|[yY]) ;;
  *)
    echo "Annulation."
    exit 0
    ;;
esac

echo "[0/6] Nettoyage de l'ancienne configuration (le cas échéant)..."
# Démontage propre si monté
if mountpoint -q "$mount_point"; then
  umount "$mount_point" || true
fi

# Arrêt de la grappe RAID si elle existe
if [[ -b "$raid_device" ]]; then
  mdadm --stop "$raid_device" || true
fi

# Suppression de la ligne correspondante dans /etc/fstab pour éviter les erreurs au redémarrage
if grep -q "$raid_device" /etc/fstab; then
  sed -i "\|$raid_device|d" /etc/fstab
fi

# Nettoyage optionnel de mdadm.conf (suppression des anciennes lignes de métadonnées md0)
if [ -f /etc/mdadm/mdadm.conf ]; then
  sed -i "\|\b$raid_device\b|d" /etc/mdadm/mdadm.conf || true
fi

echo "[1/6] Installation de mdadm et parted..."
apt update
apt install -y mdadm parted

echo "[2/6] Effacement des signatures et superblocs existants..."
# Efface d'abord les superblocs RAID résiduels sur les partitions ou disques
mdadm --zero-superblock "$partition1" "$partition2" 2>/dev/null || true
wipefs -a "$disk1" "$disk2"

# Create GPT partition table and one partition using all disk space
for disk in "$disk1" "$disk2"; do
  echo "Configuration du disque $disk..."
  parted -s "$disk" mklabel gpt
  parted -s "$disk" mkpart primary 0% 100%
done

partprobe "$disk1" "$disk2"
sleep 2

if [[ ! -b "$partition1" || ! -b "$partition2" ]]; then
  echo "Erreur : les partitions n'ont pas été créées correctement."
  exit 1
fi

echo "[3/6] Création du RAID 1..."
mdadm --create "$raid_device" --level=1 --raid-devices=2 "$partition1" "$partition2" --force

echo "[4/6] Formatage du RAID..."
mkfs.ext4 -F "$raid_device"

echo "[5/6] Montage du RAID..."
mkdir -p "$mount_point"
mount "$raid_device" "$mount_point"

echo "[6/6] Configuration de démarrage..."
# Ajout propre de la configuration dans mdadm.conf sans doublons massifs
mdadm --detail --scan >> /etc/mdadm/mdadm.conf
update-initramfs -u

echo "$raid_device $mount_point ext4 defaults,nofail 0 0" >> /etc/fstab

cat <<EOF

RAID 1 créé avec succès.
Point de montage : $mount_point
Vérification :
  cat /proc/mdstat
  mdadm --detail $raid_device
EOF