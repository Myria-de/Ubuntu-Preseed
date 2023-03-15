#!/bin/bash
# System in Qemu starten
# Name der virtuellen Festplatte
HDDFILE="hda.qcow2"
# Qemu starten
qemu-system-x86_64 -M pc -enable-kvm -cpu host -m 4096 \
-device virtio-net-pci,netdev=net0,romfile="" \
-netdev type=user,id=net0 \
-device virtio-blk-pci,drive=drv0 \
-drive format=qcow2,file=$HDDFILE,if=none,id=drv0 \
-object rng-random,filename=/dev/urandom,id=rng0 \
-device virtio-rng-pci,rng=rng0 \

