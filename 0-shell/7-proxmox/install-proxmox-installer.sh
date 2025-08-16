#!/bin/bash
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" \
  | sudo tee /etc/apt/sources.list.d/pve-install-repo.list
wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O- \
  | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg
sudo apt auto-remove && apt-get clean && apt-get update && apt-get upgrade

sudo apt install proxmox-installer
