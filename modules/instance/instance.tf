resource "google_compute_instance" "default" {
  machine_type = var.machine_type
  name         = var.instance_name
  zone         = var.zone
  project      = var.project

  boot_disk {
    initialize_params {
      image = var.boot_image
      type  = "pd-standard"
      size  = var.disk_size
    }
  }

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }
  }

  metadata = {
    "ssh-keys" : var.ssh_key
  }
}

output "ip_address" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
