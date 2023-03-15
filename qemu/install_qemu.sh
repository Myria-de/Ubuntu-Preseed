#!/bin/bash
# System in Qemu installieren
# Pfad zur ISO-Datei mit dem Live-System
ISOPATH="/home/te/Cubic-22.04-full/ubuntu-22.04.1-2023.03.12-desktop-amd64.iso"
# Name der virtuellen Festplatte
HDDFILE="hda.qcow2"
# Damit die komplett automatische Installation funktioniert
# muss in auto-inst.seed die virtuelle Festplatte mit
# d-i partman-auto/disk string /dev/vda
# angegeben sein.
# Bei Standard-Hardware dagegen beispielsweise /dev/sda
#
# Virtuelle Festplatte mit 16GB erstellen
if [ ! -f $HDDFILE ]; then
qemu-img create -f qcow2 $HDDFILE 16G
fi
# qemu starten
qemu-system-x86_64 -M pc -enable-kvm -cpu host -m 4096 \
-device virtio-net-pci,netdev=net0,romfile="" \
-netdev type=user,id=net0 \
-device virtio-blk-pci,drive=drv0 \
-drive format=qcow2,file=$HDDFILE,if=none,id=drv0 \
-object rng-random,filename=/dev/urandom,id=rng0 \
-device virtio-rng-pci,rng=rng0 \
-device virtio-scsi \
-device scsi-cd,drive=cd \
-drive if=none,id=cd,format=raw,file=$ISOPATH
