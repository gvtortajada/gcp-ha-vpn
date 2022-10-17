variable "project_id" {}

resource "google_project_organization_policy" "requireOsLogin" {
  project     = var.project_id
  constraint = "compute.requireOsLogin"
 
  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "requireShieldedVm" {
  project     = var.project_id
  constraint = "compute.requireShieldedVm"
 
  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "restrictVpcPeering" {
    project     = var.project_id
    constraint = "compute.restrictVpcPeering"
 
    list_policy {
        allow {
            all = true
        }
    }
}

resource "google_project_organization_policy" "restrictVpnPeerIPs" {
    project     = var.project_id
    constraint = "compute.restrictVpnPeerIPs"
 
    list_policy {
        allow {
            all = true
        }
    }
}