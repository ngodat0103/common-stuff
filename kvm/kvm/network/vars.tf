variable "network_name" {
        type = string
        description = "The name of the network"
}
variable "network_mode" {
        type = string
        description = "The mode of the network"
}
variable "network_domain" {
        type = string
        description = "The domain of the network"
}
variable "network_subnets" {
        type = list(string)
        description = "The subnets of the network"
}