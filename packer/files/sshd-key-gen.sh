#!/usr/bin/env bash
# sshd-key-gen.sh
# post-apply script that properly manages ssh authentication keys
# Add this to the template and call from /etc/rc.local
#
#
# Author: http://arstechnica.com/civis/viewtopic.php?p=24477553&sid=2f36719ac25cf1149163626a90c6edb3#p24477553
#
 
SSHKEYGEN=/usr/bin/ssh-keygen
 
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    $SSHKEYGEN -q -t rsa  -f /etc/ssh/ssh_host_rsa_key -N "" \
        -C "" < /dev/null > /dev/null 2> /dev/null
    echo "Created /etc/ssh_host_rsa_key"
fi
 
if [ ! -f /etc/ssh/ssh_host_dsa_key ]; then
    $SSHKEYGEN -q -t dsa  -f /etc/ssh/ssh_host_dsa_key -N "" \
        -C "" < /dev/null > /dev/null 2> /dev/null
    echo "Created /etc/ssh_host_dsa_key"
fi
 
exit 0
