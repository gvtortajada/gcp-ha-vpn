variable "project_id" {}
variable "region" {}
variable "vpc_network" {}
variable "peer_gateway_ip" {}
variable "asn" {}
variable "shared_secret" {}
variable "peer_asn" {}
variable "router_interface1_ip_range" {}
variable "router_peer1_ip" {}
variable "router_interface2_ip_range" {}
variable "router_peer2_ip" {}

resource "google_compute_ha_vpn_gateway" "ha_gateway" {
  region  = var.region
  name    = "ha-vpn-gateway"
  network = var.vpc_network.id
  project = var.project_id
}

resource "google_compute_external_vpn_gateway" "external_gateway" {
  name            = "external-vpn-gateway"
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
  description     = "Externally managed VPN gateway"
  project         = var.project_id
  interface {
    id         = 0
    ip_address = var.peer_gateway_ip
  }
}

resource "google_compute_router" "vpn_router" {
  name    = "ha-vpn-router"
  network = var.vpc_network.id
  region  = var.region
  project = var.project_id
  bgp {
    asn = var.asn
  }
}

resource "google_compute_vpn_tunnel" "tunnel1" {
  name                            = "ha-vpn-tunnel1"
  region                          = var.region
  project                         = var.project_id
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha_gateway.id
  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.id
  peer_external_gateway_interface = 0
  shared_secret                   = var.shared_secret
  router                          = google_compute_router.vpn_router.id
  vpn_gateway_interface           = 0
}

resource "google_compute_vpn_tunnel" "tunnel2" {
  name                            = "ha-vpn-tunnel2"
  region                          = var.region
  project                         = var.project_id
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha_gateway.id
  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.id
  peer_external_gateway_interface = 0
  shared_secret                   = var.shared_secret
  router                          = google_compute_router.vpn_router.id
  vpn_gateway_interface           = 1
}

resource "google_compute_router_interface" "vpn_router_interface1" {
  name       = "vpn-router-interface1"
  router     = google_compute_router.vpn_router.name
  project    = var.project_id
  region     = var.region
  ip_range   = var.router_interface1_ip_range
  vpn_tunnel = google_compute_vpn_tunnel.tunnel1.name
}

resource "google_compute_router_peer" "vpn_router_peer1" {
  name                      = "router-peer1"
  router                    = google_compute_router.vpn_router.name
  project                   = var.project_id
  region                    = var.region
  peer_ip_address           = var.router_peer1_ip
  peer_asn                  = var.peer_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.vpn_router_interface1.name
}

resource "google_compute_router_interface" "vpn_router_interface2" {
  name       = "vpn-router-interface2"
  router     = google_compute_router.vpn_router.name
  project    = var.project_id
  region     = var.region
  ip_range   = var.router_interface2_ip_range
  vpn_tunnel = google_compute_vpn_tunnel.tunnel2.name
}

resource "google_compute_router_peer" "vpn_router_peer2" {
  name                      = "router-peer2"
  router                    = google_compute_router.vpn_router.name
  project                   = var.project_id
  region                    = var.region
  peer_ip_address           = var.router_peer2_ip
  peer_asn                  = var.peer_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.vpn_router_interface2.name
}

