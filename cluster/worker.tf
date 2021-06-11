data "template_file" "worker" {
  template = file("./scripts/worker.sh")
  vars = {
    token          = random_string.token.result
    server_address = google_compute_instance.master.network_interface.0.network_ip
  }
}

resource "google_compute_instance" "worker" {
  count        = var.total_node
  machine_type = var.machine_type
  name         = "${var.group_name}-worker-${count.index + 1}"
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = var.boot_image
      type  = "pd-standard"
      size  = var.disk_size
    }
  }
  tags = ["${var.group_name}-worker"]
  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnetwork.name
    access_config {
      network_tier = "PREMIUM"
    }
  }
  metadata = {
    "ssh-keys" : var.ssh_key
  }

  metadata_startup_script = data.template_file.worker.rendered
  depends_on = [google_compute_instance.master]
}
