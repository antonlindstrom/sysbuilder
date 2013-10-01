#!/usr/bin/env bash

VM_HOSTNAME=$1
VM_TEMPLATE=ubuntu1204.qcow
VM_IMAGE=$VM_HOSTNAME.qcow

# We require hostname
if [ -x $VM_HOSTNAME ]; then
  echo "This script requires argument hostname"
  echo "Usage: ./$0 [HOSTNAME]"
  exit 1
fi

# This is probably something we want to know first
if [ -f $VM_IMAGE ]; then
  echo "Image $VM_IMAGE exists, I'm refusing to build it again."
  exit 2
fi

# This script should only be run with root privileges
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

echo "Copying image ..."
cp $VM_TEMPLATE $VM_IMAGE

# Check if copy was successful
if [ $? != 0 ]; then
  echo "Failed to copy $VM_TEMPLATE" >&2
  exit 3
fi

# Scrub all default data for our new host
virt-sysprep --enable ssh-hostkeys,dhcp-client-state,bash-history,logfiles,random-seed,udev-persistent-net,net-hwaddr,hostname \
--hostname $VM_HOSTNAME \
-a $VM_IMAGE

# Check if all is well
if [ $? != 0 ]; then
  rm $VM_IMAGE
  echo "Failed to build $VM_HOSTNAME" >&2
  exit 4
fi

#TODO: import this image and fix XML to virsh
#TODO: virsh start

echo " => $VM_IMAGE is done."
