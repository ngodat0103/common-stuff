terraform {
  required_providers {
    libvirt = {
      source = "nv6/libvirt"
      version = "0.7.1"
    }
  }
}
resource "libvirt_volume" "ubuntu_desktop_2204_iso" {
  name   = "ubuntu-desktop-2204-vm.iso"
  pool = var.pool_name
  source = "https://releases.ubuntu.com/jammy/ubuntu-22.04.5-desktop-amd64.iso"
}