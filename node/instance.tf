resource "google_compute_instance" "default" {
  count        = var.total_node
  machine_type = var.machine_type
  name         = "${var.group_name}-${count.index + 1}"
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = var.boot_image
      type  = "pd-standard"
      size  = var.disk_size
    }
  }
  tags = ["${var.group_name}"]
  network_interface {

    subnetwork = google_compute_subnetwork.vpc_subnetwork.name
    access_config {
      network_tier = "PREMIUM"
    }
  }

  metadata = {
    "ssh-keys" : var.ssh_key
  }
}
