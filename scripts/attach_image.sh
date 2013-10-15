#!/usr/bin/env bash

# For hot plugging.
#
# modprobe acpiphp
# modprobe pci_hotplug
#

VM_HOSTNAME=$1
DISK=$2
SIZE=$3

if [ -x $VM_HOSTNAME ]; then
  echo "This script requires argument hostname"
  echo "Usage: $0 [HOSTNAME] [DISK] [SIZE] [STORE PATH]"
  exit 1
fi

if [ -x $DISK ]; then
  echo "This script requires argument disk (ex vdb)"
  echo "Usage: $0 [HOSTNAME] [DISK] [SIZE] [STORE PATH]"
  exit 1
fi

if [ -x $SIZE ]; then
  echo "This script requires argument size (ex 50G)"
  echo "Usage: $0 [HOSTNAME] [DISK] [SIZE] [STORE PATH]"
  exit 1
fi

if [ -n $4 ]; then
  STORE_PATH=$4
  echo "STORE_PATH set, using: $STORE_PATH"
else
  STORE_PATH=/var/lib/libvirt/images
  echo "No STORE_PATH, using: $STORE_PATH"
fi

IMAGE=$STORE_PATH/$HOSTNAME-$DISK.qcow
DEFIN=$STORE_PATH/$HOSTNAME-$DISK.xml

QEMU_IMG=$(which qemu-img)

if [ $? != 0 ]; then
  echo "qemu-img does not exist!"
  exit 2
fi

$QEMU_IMG create -f qcow $IMAGE $SIZE > /dev/null

if [ $? != 0 ]; then
  echo "Failed to build image!"
  exit 2
fi

echo "<disk type='file' device='disk'>
  <driver name='qemu' type='qcow' cache='writeback'/>
  <source file='$IMAGE'/>
  <target dev='$DISK' bus='virtio'/>
</disk>" > $DEFIN

virsh attach-device $VM_HOSTNAME $DEFIN
