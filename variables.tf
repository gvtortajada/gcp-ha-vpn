variable "region" {
  description = "The region"
  default     = "northamerica-northeast1"
}

variable "ip_cidr_range" {
  default = "10.128.0.0/24"
}

variable "vpc_network" {
  description = "The VPC network"
  default     = "network"
}

variable "vpc_sub_network" {
  description = "The subnetwork"
  default     = "subnet"
}

variable "peer_gateway_ip" {
  description = "Peer gateway IP"
  default     = "8.8.8.8"
}

variable "asn" {
  description = "ASN"
  default     = "64514"
}

variable "shared_secret" {
  description = "Shared secret used to set the secure session between the Cloud VPN gateway and the peer VPN gateway"
  default     = "shared-secret"
}

variable "peer_asn" {
  description = "peer asn"
  default     = "64515"
}

variable "router_interface1_ip_range" {
  description = "router interface ip range"
  default = "169.254.0.1/30"
}

variable "router_peer1_ip" {
  description = "router peer ip"
  default = "169.254.0.2"
}

variable "router_interface2_ip_range" {
  description = "router interface ip range"
  default = "169.254.1.1/30"
}

variable "router_peer2_ip" {
  description = "router peer ip"
  default = "169.254.1.2"
}