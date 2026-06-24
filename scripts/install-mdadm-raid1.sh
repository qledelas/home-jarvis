#!/usr/bin/env bash
set -euo pipefail

# Installer mdadm et créer un RAID 1 sur deux disques
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

echo "Vous allez créer un RAID 1 sur :"
echo "  - $disk1"
echo "  - $disk2"
echo "Le contenu des disques sera effacé."
read -r -p "Continuer ? [y/N] " response
case "$response" in
  [yY][eE][sS]|[yY]) ;;
  *)
    echo "Annulation."
    exit 0
    ;;
esac

echo "[1/6] Installation de mdadm et parted..."
apt-get update
apt-get install -y mdadm parted

echo "[2/6] Effacement des signatures existantes..."
wipefs -a "$disk1" "$disk2"

# Create GPT partition table and one partition using all disk space
for disk in "$disk1" "$disk2"; do
  echo "Configuration du disque $disk..."
  parted -s "$disk" mklabel gpt
  parted -s "$disk" mkpart primary 0% 100%
done

partprobe "$disk1" "$disk2"

if [[ ! -b "$partition1" || ! -b "$partition2" ]]; then
  echo "Erreur : les partitions n'ont pas été créées correctement."
  exit 1
fi

echo "[3/6] Création du RAID 1..."
mdadm --create "$raid_device" --level=1 --raid-devices=2 "$partition1" "$partition2"

echo "[4/6] Formatage du RAID..."
mkfs.ext4 -F "$raid_device"

echo "[5/6] Montage du RAID..."
mkdir -p "$mount_point"
mount "$raid_device" "$mount_point"

echo "[6/6] Configuration de démarrage..."
mdadm --detail --scan | tee -a /etc/mdadm/mdadm.conf >/dev/null
update-initramfs -u

echo "$raid_device $mount_point ext4 defaults,nofail 0 0" >> /etc/fstab

cat <<EOF

RAID 1 créé avec succès.
Point de montage : $mount_point
Vérification :
  cat /proc/mdstat
  mdadm --detail $raid_device
EOF
