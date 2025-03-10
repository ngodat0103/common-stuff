output "network_name"{ 
  value = var.network_name
}
output "network_mode"{ 
  value = var.network_mode
}
output "network_id" {
        value = libvirt_network.default.id
}