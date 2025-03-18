
terraform {
  required_providers {
    libvirt = {
      source = "nv6/libvirt"
      version = "0.7.1"
    }
  }
}



resource "libvirt_volume" "vm_disk" {
  name   = "${var.vm_name}-vm-disk.qcow2"
  pool   = var.pool_name
  size  = var.vm_disk_size
}

resource "libvirt_domain" "default" {
  depends_on = [libvirt_volume.vm_disk]
  name   = var.vm_name
  memory = var.vm_memory
  vcpu   = var.vm_vcpu
  cpu {
    mode = "host-passthrough"
  }


  disk {
        volume_id = var.iso_volume_id
  }
  disk {
    volume_id = libvirt_volume.vm_disk.id
  }
  boot_device {
    dev = ["hd","cdrom","network"]  # Boot from ISO first
  }

  
  network_interface {
    network_name = var.vm_network_name
    addresses   = var.vm_network_address
  }
   console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
  graphics {
    type        = "vnc"
    listen_type = "address"
  }
   video {
    type = "vga"
  }
}