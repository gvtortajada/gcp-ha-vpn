variable "project_id" {}
variable "region" {}
variable "vpc_network" {}
variable "vpc_sub_network" {}
variable "ip_cidr_range" {}

resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.vpc_network
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "vpc_sub_network" {
  name                     = var.vpc_sub_network
  project                  = var.project_id
  ip_cidr_range            = var.ip_cidr_range
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
}

output "vpc_network" {
  value = google_compute_network.vpc_network
}

output "vpc_sub_network" {
  value = google_compute_subnetwork.vpc_sub_network
}
