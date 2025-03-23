#!/usr/bin/env bash
WORKDIR=`pwd`
VMNAME=linux-mint-22-cubic
VMDIR=$WORKDIR/VMs
ISOFILE=$WORKDIR/ISO/linux-mint-22-custom.iso
IMAGENAME=$VMNAME.qcow2
IMAGEPATH=$VMDIR/$VMNAME/$IMAGENAME
#IMAGEPATH=/var/lib/libvirt/images/$IMAGENAME
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
  --boot firmware=efi,firmware.feature0.enabled=no,firmware.feature0.name=secure-boot \
  --graphics spice \
  --noautoconsole 
# optional, maybe necessary
#sudo chown libvirt-qemu:kvm $IMAGEPATH
virt-manager --connect qemu:///system --show-domain-console $VMNAME
