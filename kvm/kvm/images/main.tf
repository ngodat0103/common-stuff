terraform {
  required_providers {
    libvirt = {
      source = "nv6/libvirt"
      version = "0.7.1"
    }
  }
}
resource "libvirt_pool" "default" {
  name = "default"
  type = "dir"
  path = "/var/lib/libvirt/images"
  lifecycle {
     prevent_destroy = true
  }
}
resource "libvirt_volume" "ubuntu_2204_disk" {
  name   = "ubuntu2204-vm.qcow2"
  pool   = libvirt_pool.default.name
  source = "https://cloud-images.ubuntu.com/releases/22.04/release-20250228/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img"
  lifecycle {
    prevent_destroy = true
  }
}