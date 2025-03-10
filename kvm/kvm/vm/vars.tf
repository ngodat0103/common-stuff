variable "vm_name" {
        type = string
        description = "The name of the VM"
}
variable "vm_memory" {
        type = number
        description = "The memory of the VM"
}
variable "vm_vcpu" {
        type = number
        description = "The number of vCPUs of the VM"
}
variable "vm_disk_size" {
        type = number
        description = "The size of the disk of the VM in bytes"
        default = 21474836480
} 
variable "vm_network_name" {
        type = string
        description = "The network name of the VM"
} 
variable "vm_network_address" {
        type = list(string)
        description = "The network address of the VM"
} 
variable "username" {
        type = string
        default = "ubuntu"
        description = "The username of the VM"
}
variable "ssh_key" {
        type = string
        description = "The SSH key of the VM"
}
variable "pool_id" {
        type = string
        description = "The pool id of the commoninit disk"
}
variable "base_volume_id" {
        type = string
        description = "The base volume id of the VM disk"
}
