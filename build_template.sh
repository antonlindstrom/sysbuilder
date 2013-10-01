#!/usr/bin/env bash

NEW_HOSTNAME=$1
NEW_MEMORY=524288
NEW_VCPU=1
NEW_QCOW_PATH=/mnt/storage/vms/${NEW_HOSTNAME}.qcow
NEW_BRIDGE_IF=br0


# Do not change below
NEW_UUID=$(uuid)
NEW_MAC_ADDR=$(printf '52:54:01:%02X:%02X:%02X\n' $[RANDOM%256] $[RANDOM%256] $[RANDOM%256])

if [ -x $NEW_HOSTNAME ]; then
  echo "This script requires argument hostname"
  echo "Usage: ./$0 [HOSTNAME]"
  exit 1
fi

if [ -f ${NEW_HOSTNAME}.xml ]; then
  echo "Image ${NEW_HOSTNAME}.xml exists, I'm refusing to build it again."
  exit 2
fi

cp kvm/template.xml ${NEW_HOSTNAME}.xml

sed -i -e "s/NEW_UUID/$UUID/" ${NEW_HOSTNAME}.xml
sed -i -e "s/NEW_HOSTNAME/$NEW_HOSTNAME/" ${NEW_HOSTNAME}.xml
sed -i -e "s/NEW_MEMORY/$NEW_MEMORY/" ${NEW_HOSTNAME}.xml
sed -i -e "s/NEW_VCPU/$NEW_VCPU/" ${NEW_HOSTNAME}.xml
sed -i -e "s,NEW_QCOW_PATH,$NEW_QCOW_PATH," ${NEW_HOSTNAME}.xml
sed -i -e "s/NEW_BRIDGE_IF/$NEW_BRIDGE_IF/" ${NEW_HOSTNAME}.xml
sed -i -e "s/NEW_MAC_ADDR/$NEW_MAC_ADDR/" ${NEW_HOSTNAME}.xml
sed -i -e "s/NEW_UUID/$NEW_UUID/" ${NEW_HOSTNAME}.xml

echo " => New definition: ${NEW_HOSTNAME}.xml"
