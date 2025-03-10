terraform {
  required_providers {
    libvirt = {
      source = "nv6/libvirt"
      version = "0.7.1"
    }
  }
}
resource "libvirt_network" "default" {
  name      = var.network_name
  mode      = var.network_mode
  domain    = var.network_domain
  addresses = var.network_subnets
  autostart = true

  dhcp {
    enabled = true
  }

  dns {
    enabled = true
  }
}