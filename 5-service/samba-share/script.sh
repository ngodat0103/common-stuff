#!/bin/bash
set -e
SHARE_URL="//192.168.1.120/akira-sharing"
MOUNT_POINT="/mnt/samba_share"
ip_address=$(ip route get 1.1.1.1 | awk '{print $7}')
if [[ $ip_address =~ ^192\.168\.1\.[0-9]+$ ]]; then
    echo "At home! Mounting Samba share..."
    sudo mount -t cifs -o username=$SMB_USERNAME,password=$SMB_PASSWORD,uid=1000,gid=1000 //192.168.1.120/akira-sharing /mnt/samba-share
else
    echo "Outside home! Starting VPN first..."
    # VPN command here
fi
