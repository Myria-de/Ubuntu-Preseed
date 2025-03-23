#!/bin/bash

# install firefox deb package
if grep -q firefoxdeb /proc/cmdline ; then
  FIREFOXDEB="yes"
fi
# install chromium deb package
if grep -q chromiumdeb /proc/cmdline ; then
  CHROMIUMDEB="yes"
fi

if grep -q ubuntu /proc/cmdline ; then
  DESKTOPPKG="ubuntu-desktop^"
fi
if grep -q xubuntu /proc/cmdline ; then
  DESKTOPPKG="xubuntu-desktop^"
fi
if grep -q kde /proc/cmdline ; then
  DESKTOPPKG="kubuntu-desktop^"
fi
if grep -q cinnamon /proc/cmdline ; then
  DESKTOPPKG="cinnamon-desktop-environment"
fi

# Install desktop
apt -y install $DESKTOPPKG

# Let NetworkManager handle network
cp /root/00-network-manager-all.yaml /usr/lib/netplan

# Zusätzliche Pakete installieren
# Additional packages
# apt -y install openssh-server
# apt -y install samba synaptic
# qemu (clipboard)
# apt -y install spice-vdagent

################# Cinnamon optional ###################
if [ "$DESKTOPPKG" == "cinnamon-desktop-environment" ]
then
# pidgin causes a crash
apt -y remove pidgin
# Mint Pakete für einen Desktop herunterladen, der mehr nach Minux Mint aussieht.
# Download Mint packages for a desktop that looks more like Linux Mint.
mkdir /root/mint-themes
cd /root/mint-themes
wget http://packages.linuxmint.com/pool/main/m/mint-x-icons/mint-x-icons_1.7.2_all.deb

wget http://packages.linuxmint.com/pool/main/m/mint-y-icons/mint-y-icons_1.8.3_all.deb

wget http://packages.linuxmint.com/pool/main/m/mint-themes/mint-themes_2.2.3_all.deb

wget http://packages.linuxmint.com/pool/main/m/mint-l-theme/mint-l-theme_1.9.9_all.deb

wget http://packages.linuxmint.com/pool/main/m/mint-l-icons/mint-l-icons_1.7.4_all.deb

wget http://packages.linuxmint.com/pool/main/m/mint-backgrounds-wilma/mint-backgrounds-wilma_1.1_all.deb

wget http://packages.linuxmint.com/pool/main/m/mint-backgrounds-wallpapers/mint-backgrounds-wallpapers_1.0_all.deb

wget http://packages.linuxmint.com/pool/main/m/mint-cursor-themes/mint-cursor-themes_1.0.2_all.deb

wget http://packages.linuxmint.com/pool/main/m/mint-translations/mint-translations_2025.01.06_all.deb

wget http://packages.linuxmint.com/pool/main/m/mint-artwork/mint-artwork_1.8.9_all.deb
wget http://packages.linuxmint.com/pool/main/m/mint-common/mint-common_2.4.6_all.deb
wget http://packages.linuxmint.com/pool/main/m/mint-info/mint-info-cinnamon_2024.11.20_all.deb

sudo apt -y install ./mint-x-icons_1.7.2_all.deb
sudo apt -y install ./mint-y-icons_1.8.3_all.deb
sudo apt -y install ./mint-themes_2.2.3_all.deb
sudo apt -y install ./mint-l-icons_1.7.4_all.deb
sudo apt -y install ./mint-l-theme_1.9.9_all.deb
sudo apt -y install ./mint-translations_2025.01.06_all.deb
sudo apt -y install ./mint-cursor-themes_1.0.2_all.deb
sudo apt -y install ./mint-artwork_1.8.9_all.deb
sudo apt -y install ./mint-common_2.4.6_all.deb
sudo apt -y install ./mint-backgrounds-wilma_1.1_all.deb
sudo apt -y install ./mint-backgrounds-wallpapers_1.0_all.deb
sudo apt -y install ./mint-info-cinnamon_2024.11.20_all.deb

#clean
cd .. && sudo rm -rf mint-themes/

if [ ! -e /etc/dconf/db/local.d ]
then 
 mkdir -p /etc/dconf/db/local.d
fi

cp /root/15-cinnamon-settings /etc/dconf/db/local.d/

if [ ! -e /etc/dconf/profile ]
then
 mkdir -p /etc/dconf/profile  
fi

cp /root/user /etc/dconf/profile
dconf update

# Cinnamon Session aktivieren
# enable cinnamon session
echo '
[SeatDefaults]
user-session=cinnamon
' | tee /etc/lightdm/lightdm.conf.d/70-linuxmint.conf

fi
####################### Ubuntu ########################
if [ "$DESKTOPPKG" == "ubuntu-desktop^" ]
 then
  
  if [ ! -e /etc/dconf/db/local.d ]
  then 
   mkdir -p /etc/dconf/db/local.d
  fi
  # Nautilus defaults optional
  cp /root/20-nautilus-settings /etc/dconf/db/local.d/
  # Firefox dock icon
  if [ "$FIREFOXDEB" == "yes" ]
  then
   cp /root/30-firefox-settings /etc/dconf/db/local.d/
  fi
  
  if [ ! -e /etc/dconf/profile ]
  then
   mkdir -p /etc/dconf/profile  
  fi
  cp /root/user /etc/dconf/profile

  dconf update

  # "Welcome" deaktivieren optional
  if [ -e /etc/xdg/autostart/gnome-initial-setup-first-login.desktop ]
   then
     sed -i 's/Exec=/#Exec=/' /etc/xdg/autostart/gnome-initial-setup-first-login.desktop
     if [ -e /usr/lib/systemd/user/gnome-initial-setup-first-login.service ]
       then
         cp /usr/lib/systemd/user/gnome-initial-setup-first-login.service /etc/systemd/user/
         sed -i 's/ConditionPathExists=!%E\/gnome-initial-setup-done/ConditionPathExists=%E\/no-gnome-initial-setup-done/' /etc/systemd/user/gnome-initial-setup-first-login.service
     fi
  fi
fi

# Neuen Hostamen setzen (Zufallswert)
# Set new host name (random value)
new="ub-"$(tr -dc 'A-Z0-9' < /dev/urandom | head -c8)
/usr/bin/hostnamectl set-hostname "$new"
echo $new > /etc/hostname
sed -i 's/unassigned-hostname.unassigned.domain/'"$new"'/' /etc/hosts
sed -i 's/unassigned-hostname//' /etc/hosts

# Firefox deb installieren
if [ "$FIREFOXDEB" == "yes" ]
then
#firefox deb
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null

echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | tee /etc/apt/preferences.d/mozilla 

echo 'Unattended-Upgrade::Origins-Pattern {"site=packages.mozilla.org"};' | tee /etc/apt/apt.conf.d/52unattended-upgrades-firefox

apt update && apt -y --allow-downgrades install firefox
apt -y --allow-downgrades install firefox-l10n-de
fi

# Chromium deb installieren
if [ "$CHROMIUMDEB" == "yes" ]
then
source /etc/lsb-release
echo "deb https://freeshell.de/phd/chromium/${DISTRIB_CODENAME} /" \
| tee /etc/apt/sources.list.d/phd-chromium.list

cd ~
gpg --no-default-keyring --keyring gnupg-ring:~/phd-ubuntu-chromium-browser.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 869689FE09306074
mv phd-ubuntu-chromium-browser.gpg /etc/apt/trusted.gpg.d/
chown root:root /etc/apt/trusted.gpg.d/phd-ubuntu-chromium-browser.gpg
chmod ugo+r /etc/apt/trusted.gpg.d/phd-ubuntu-chromium-browser.gpg
chmod go-w /etc/apt/trusted.gpg.d/phd-ubuntu-chromium-browser.gpg

echo '
# chromium
Package: *
Pin: release origin "freeshell.de"
Pin-Priority: 1001

Package: chromium*
Pin: origin "freeshell.de"
Pin-Priority: 700

' | tee /etc/apt/preferences.d/phd-chromium-browser

echo 'Unattended-Upgrade::Origins-Pattern {"site=freeshell.de"};' | tee /etc/apt/apt.conf.d/52unattended-upgrades-chromium
apt update 
apt install -y chromium
fi

# Install German language packs
apt install -y $(check-language-support -l de)

