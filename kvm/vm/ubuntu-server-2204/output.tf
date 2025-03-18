output "ip_address" {
  value = libvirt_domain.default.network_interface.0.addresses.0
}