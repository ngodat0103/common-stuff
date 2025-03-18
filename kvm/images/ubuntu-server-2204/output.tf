output "pool_id" {
        value = libvirt_pool.default.id
}
output "pool_name" {
        value = libvirt_pool.default.name
}
output "ubuntu_2204_disk_id" {
        value = libvirt_volume.ubuntu_2204_disk.id
}