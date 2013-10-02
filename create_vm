#!/usr/bin/env bash

VM_HOSTNAME=$1

if [ -x $VM_HOSTNAME ]; then
  echo "Requires argument hostname"
  echo "Usage: $0 [HOSTNAME]"
  exit 1
fi

echo "Starting build of: $VM_HOSTNAME"

bash ./sysprep.sh $VM_HOSTNAME

if [ $? != 0 ]; then
  echo "Could not create image!"
  exit 2
fi

bash ./build_template.sh $VM_HOSTNAME

if [ $? != 0 ]; then
  echo "Could not create template!"
  exit 2
fi

mv $VM_HOSTNAME.qcow /mnt/storage/vms/$VM_HOSTNAME.qcow

echo "Starting and defining $VM_HOSTNAME"
virsh define $VM_HOSTNAME.xml > /dev/null
virsh start $VM_HOSTNAME > /dev/null
