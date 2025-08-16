#!/bin/bash

echo "Set up dns"
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

apt update
apt install vim-nox

SRC_LINE='source <(curl -fsSL https://raw.githubusercontent.com/ngodat0103/common-stuff/b3c39675ab7ae2ecb5dcc067aeab1b7791fe3330/0-shell/7-proxmox/create-admin-account.sh)'

grep -qxF "$SRC_LINE" ~/.bashrc || echo "$SRC_LINE" >> ~/.bashrc


