#!/usr/bin/env bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'''
WORKDIR=`pwd`
IMAGENAME=image_ubuntu_server_24.04.vdi
IMAGESIZE=20000
VMNAME=Ubuntu_24.04_Server_Cubic
OSTYPE=Ubuntu24_LTS_64
UEFI=--efi
VMDIR=$WORKDIR/VMs
ISOFILE=$WORKDIR/ISO/ubuntu-server-24.04-custom.iso
# Netwerkadapter konfigurieren
NICDEVICE=
NICTYPE=nat
# oder für bridge
# Bezeichnung des Netzwerkadapters siehe ip a
#NICDEVICE=enp4s0
#NICTYPE=bridged

check-state() {
if ! test $? -eq 0
then
	if ! [ -z "$1" ]
	 then
	 echo -e "${RED}Fehler: $1${NC}"
	 fi
	 exit 1
fi
}

if [ -z $(which VBoxManage) ]
 then
  echo -e "${RED}Fehler: Bitte installieren Sie zuerst Virtualbox. Abbruch.${NC}"
  exit 1
fi
VBOXPATH=$(which VBoxManage)

if [ ! -d $VMDIR/$VMNAME ]
then
echo -e "- ${GREEN}Erstelle Verzeichnis $VMDIR/$VMNAME ${NC}"
mkdir -p $VMDIR/$VMNAME
fi

IMAGEPATH=$VMDIR/$VMNAME/$IMAGENAME

echo -e "- ${GREEN}Erstelle Festplattenimage (vdi). Bitte warten...${NC}"
"$VBOXPATH" createmedium disk --filename=$IMAGEPATH --size=$IMAGESIZE --format vdi
check-state "VBoxManage: Fehler $?"

echo -e "- ${GREEN}Virtuelle Maschine mit virtueller Standard-Hardware erstellen.${NC}"
VBoxManage createvm --name="$VMNAME" --ostype "$OSTYPE" --register --basefolder "$VMDIR" --default
check-state "VBoxManage createvm: Fehler $?"

echo -e "- ${GREEN}$IMAGEPATH für die VM konfigurieren.${NC}"
VBoxManage storageattach "$VMNAME" --storagectl="SATA" --port=0 --device=0 --type=hdd --medium="$IMAGEPATH"

echo -e "- ${GREEN}Virtuelles DVD-Laufwerk erstellen.${NC}"
VBoxManage storageattach "$VMNAME" --storagectl="IDE" --port=1 --device=0 --type=dvddrive --medium="$ISOFILE"

echo -e "- ${GREEN}Netzwerkadapter konfigurieren.${NC}"
if [ "$NICTYPE" == "nat" ]; then
VBoxManage modifyvm "$VMNAME" --nic1=$NICTYPE
else
VBoxManage modifyvm "$VMNAME" --nic1=$NICTYPE --bridge-adapter1=$NICDEVICE
fi

echo -e "- ${GREEN}Datenaustausch konfigurieren (Clipboard, DragandDrop.${NC}"
VBoxManage modifyvm "$VMNAME" --clipboard=bidirectional
#VBoxManage modifyvm "$VMNAME" --draganddrop=bidirectional

if [ "$UEFI" == "--efi" ]; then
echo -e "- ${GREEN}EFI aktivieren.${NC}"
VBoxManage modifyvm "$VMNAME" --firmware efi
else
echo -e "- ${GREEN}BIOS aktivieren.${NC}"
VBoxManage modifyvm "$VMNAME" --firmware bios
fi
echo -e "- ${GREEN}USB 3.0 aktivieren.${NC}"
VBoxManage modifyvm "$VMNAME" --usb on
#VBoxManage modifyvm "$VMNAME" --usbehci on
VBoxManage modifyvm "$VMNAME" --usbxhci on

echo -e "- ${GREEN}Grafikspeicher anmpassen.${NC}"
VBoxManage modifyvm "$VMNAME" --vram=128

echo -e "- ${GREEN}Anzahl der CPUs.${NC}"
VBoxManage modifyvm "$VMNAME" --cpus=2

echo -e "- ${GREEN}RAM anpassen.${NC}"
VBoxManage modifyvm "$VMNAME" --memory=4096

echo -e "${GREEN}VM-Installation beendet.${NC}"

