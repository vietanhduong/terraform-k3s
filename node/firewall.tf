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
    ports    = ["6443"]
  }
  source_tags = ["${var.group_name}"]
}

resource "google_compute_firewall" "ingress" {
  name      = "${var.group_name}-ingress"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"
  project   = var.project_id
  source_ranges = [
    "35.247.163.94/32",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "108.162.192.0/18",
    "131.0.72.0/22",
    "141.101.64.0/18",
    "162.158.0.0/15",
    "172.64.0.0/13",
    "173.245.48.0/20",
    "188.114.96.0/20",
    "190.93.240.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17"
  ]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_tags = ["${var.group_name}"]
}
