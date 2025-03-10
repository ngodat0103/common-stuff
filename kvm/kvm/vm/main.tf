
terraform {
  required_providers {
    libvirt = {
      source = "nv6/libvirt"
      version = "0.7.1"
    }
  }
}

locals {
        cloud_init_config = templatefile("${path.module}/cloud_init.cfg", {
            hostname = var.vm_name
            username = var.username
            ssh_key = var.ssh_key
        })
        cloud_network_config = file("${path.module}/network_config.cfg")
}


data "template_file" "user_data" {
  template = local.cloud_init_config
}
data "template_file" "network_config" {
  template = local.cloud_network_config
}
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "${var.vm_name}-commoninit.iso"
  user_data      = local.cloud_init_config
  network_config = local.cloud_network_config
  pool           = var.pool_id
  
}


resource "libvirt_volume" "vm_disk" {
  name   = "${var.vm_name}-vm-disk.qcow2"
  pool   = var.pool_id
  base_volume_id = var.base_volume_id
  size  = var.vm_disk_size
}

resource "libvirt_domain" "default" {
  name   = var.vm_name
  memory = var.vm_memory
  vcpu   = var.vm_vcpu
  cpu {
    mode = "host-passthrough"
  }
  cloudinit = libvirt_cloudinit_disk.commoninit.id
  disk {
    volume_id = libvirt_volume.vm_disk.id
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
}