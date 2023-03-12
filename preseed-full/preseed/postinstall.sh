#!/bin/bash
# "Welcome" deaktivieren
sed -i 's/Exec=/#Exec=/' /etc/xdg/autostart/gnome-initial-setup-first-login.desktop
cp /usr/lib/systemd/user/gnome-initial-setup-first-login.service /etc/systemd/user/
sed -i 's/ConditionPathExists=!%E\/gnome-initial-setup-done/ConditionPathExists=%E\/no-gnome-initial-setup-done/' /etc/systemd/user/gnome-initial-setup-first-login.service

#Neuen Hostnamen setzen
new="ub-"$(tr -dc 'A-Z0-9' < /dev/urandom | head -c8)
echo $new >> /postinstall.txt
/usr/bin/hostnamectl set-hostname "$new"
echo $new > /etc/hostname
sed -i 's/unassigned-hostname.unassigned.domain/'"$new"'/' /etc/hosts
sed -i 's/unassigned-hostname//' /etc/hosts

# Zusätzliche Pakete installiern
# apt update -y && apt install -y openssh-server samba



