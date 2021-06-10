# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.group_name}-vpc"
  auto_create_subnetworks = "false"

  routing_mode = "REGIONAL"
}

resource "google_compute_router" "vpc_router" {
  name = "${var.group_name}-router"

  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc.self_link
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name                     = "${var.group_name}-subnetwork"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true
  ip_cidr_range            = var.ip_cidr_range

  secondary_ip_range = [
    {
      range_name    = "${var.group_name}-second-range"
      ip_cidr_range = var.ip_cidr_second_range
    }
  ]
}

resource "google_compute_router_nat" "vpc_nat" {
  name                               = "${var.group_name}-nat"
  project                            = var.project_id
  region                             = var.region
  router                             = google_compute_router.vpc_router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnetwork.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
