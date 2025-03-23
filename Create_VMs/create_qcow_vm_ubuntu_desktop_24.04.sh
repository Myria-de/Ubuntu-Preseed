#!/usr/bin/env bash
WORKDIR=`pwd`
VMNAME=ubuntu-24.04-desktop-cubic
VMDIR=$WORKDIR/VMs
ISOFILE=$WORKDIR/ISO/ubuntu-desktop-24.04-custom.iso
IMAGENAME=$VMNAME.qcow2
IMAGEPATH=$VMDIR/$VMNAME/$IMAGENAME
DISKSIZE=20
if [ ! -d $VMDIR/$VMNAME ]
then
echo -e "- ${GREEN}Erstelle Verzeichnis $VMDIR/$VMNAME ${NC}"
mkdir -p $VMDIR/$VMNAME
fi
qemu-img create -f qcow2 -o preallocation=metadata "${IMAGEPATH}" ${DISKSIZE}G
#sudo chown libvirt-qemu:kvm $IMAGEPATH

virt-install \
  --connect qemu:///system \
  --virt-type kvm \
  --name $VMNAME \
  --vcpus 2 \
  --memory 4096 \
  --os-variant ubuntu24.04 \
  --disk $IMAGEPATH,size=20,format=qcow2,bus=virtio \
  --cdrom $ISOFILE \
  --network bridge=br0 \
  --boot uefi \
  --graphics spice \
  --noautoconsole 

virt-manager --connect qemu:///system --show-domain-console $VMNAME
