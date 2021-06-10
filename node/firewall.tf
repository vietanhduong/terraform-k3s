resource "google_compute_firewall" "ssh" {
  name          = "${var.group_name}-ssh" 
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  project       = var.project_id
  source_ranges = ["35.247.163.94/32"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "internal" {
  name          = "${var.group_name}-internal" 
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  project       = var.project_id
  source_ranges = [var.ip_cidr_range]

  allow {
    protocol = "all"
  }
	source_tags = ["${var.group_name}"]
}

resource "google_compute_firewall" "cluster" {
  name          = "${var.group_name}-cluster" 
  network       = google_compute_network.vpc.name
  direction     = "INGRESS"
  project       = var.project_id
  source_ranges = ["35.247.163.94/32"]

  allow {
    protocol = "tcp"
		ports = ["6443"]
  }
	source_tags = ["${var.group_name}"]
}