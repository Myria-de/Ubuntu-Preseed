#!/usr/bin/env bash
# Neuen Hostamen setzen (Zufallswert)
# Set random hostname
new="ub-"$(tr -dc 'A-Z0-9' < /dev/urandom | head -c8)
echo $new >> /postinstall.txt
/usr/bin/hostnamectl set-hostname "$new"
echo $new > /etc/hostname
sed -i 's/unassigned-hostname.unassigned.domain/'"$new"'/' /etc/hosts
sed -i 's/unassigned-hostname//' /etc/hosts
# Install german language packs
apt install -y $(check-language-support -l de)

# Zusätzliche Pakete installieren
# Additional packages
# apt update -y && apt install -y openssh-server samba

