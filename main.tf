provider "google" {
}

terraform {
  backend "gcs" {}
}

variable "project_id" {
}

data "google_project" "project" {
  project_id = var.project_id
}

module "apis" {
  source     = "./apis"
  project_id = var.project_id
}

module "iam" {
  source     = "./iam"
  project_id = var.project_id
  depends_on = [
    module.apis
  ]
}

module "network" {
  source          = "./network"
  project_id      = var.project_id
  region          = var.region
  vpc_network     = var.vpc_network
  vpc_sub_network = var.vpc_sub_network
  ip_cidr_range   = var.ip_cidr_range
  depends_on = [
    module.apis
  ]
}

module "vpn" {
  source                     = "./vpn"
  project_id                 = var.project_id
  region                     = var.region
  vpc_network                = module.network.vpc_network
  peer_gateway_ip            = var.peer_gateway_ip
  asn                        = var.asn
  shared_secret              = var.shared_secret
  peer_asn                   = var.peer_asn
  router_interface1_ip_range = var.router_interface1_ip_range
  router_peer1_ip            = var.router_peer1_ip
  router_interface2_ip_range = var.router_interface2_ip_range
  router_peer2_ip            = var.router_peer2_ip
  depends_on = [
    module.apis,
    module.iam,
    module.network
  ]
}




