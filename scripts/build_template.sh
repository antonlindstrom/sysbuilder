#!/usr/bin/env bash

NEW_HOSTNAME=$1
NEW_VM_PATH=$2
NEW_MEMORY=524288
NEW_VCPU=1
NEW_QCOW_PATH=$NEW_VM_PATH/${NEW_HOSTNAME}.qcow
NEW_BRIDGE_IF=br0
NEW_DEFINITION=$NEW_VM_PATH/${NEW_HOSTNAME}.xml

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Do not change below
NEW_UUID=$(uuid)
NEW_MAC_ADDR=$(printf '52:54:01:%02X:%02X:%02X\n' $[RANDOM%256] $[RANDOM%256] $[RANDOM%256])

if [ -x $NEW_HOSTNAME ]; then
  echo "This script requires argument hostname"
  echo "Usage: $0 [HOSTNAME]"
  exit 1
fi

if [ ! -n $NEW_VM_PATH ]; then
  echo "This script requires argument vm_path"
  echo "Usage: $0 [HOSTNAME] [TEMPLATE] [VM_PATH]"
  exit 1
fi

if [ -f $NEW_DEFINITION ]; then
  echo "Image $NEW_DEFINITION exists, I'm refusing to build it again."
  exit 2
fi

cp $DIR/../kvm/template.xml $NEW_DEFINITION

sed -i -e "s/NEW_UUID/$UUID/" $NEW_DEFINITION
sed -i -e "s/NEW_HOSTNAME/$NEW_HOSTNAME/" $NEW_DEFINITION
sed -i -e "s/NEW_MEMORY/$NEW_MEMORY/" $NEW_DEFINITION
sed -i -e "s/NEW_VCPU/$NEW_VCPU/" $NEW_DEFINITION
sed -i -e "s,NEW_QCOW_PATH,$NEW_QCOW_PATH," $NEW_DEFINITION
sed -i -e "s/NEW_BRIDGE_IF/$NEW_BRIDGE_IF/" $NEW_DEFINITION
sed -i -e "s/NEW_MAC_ADDR/$NEW_MAC_ADDR/" $NEW_DEFINITION
sed -i -e "s/NEW_UUID/$NEW_UUID/" $NEW_DEFINITION

echo " => New definition: $NEW_DEFINITION"
