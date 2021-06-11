resource "random_string" "token" {
  length           = 108
  special          = true
  number           = true
  lower            = true
  upper            = true
  override_special = ":"
}


data "template_file" "master" {
  template = file("./scripts/master.sh")
  vars = {
    token                  = random_string.token.result
    external_lb_ip_address = google_compute_address.master.address

    // Uncomment if you're using database
    /* db_username            = google_sql_user.storage.name
    db_password            = google_sql_user.storage.password
    db_host                = google_sql_database_instance.storage.private_ip_address */
  }
}

resource "google_compute_address" "master" {
  name         = "eip-${var.group_name}"
  network_tier = "PREMIUM"
}

resource "google_compute_instance" "master" {
  machine_type = var.machine_type
  name         = "${var.group_name}-master"
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = var.boot_image
      type  = "pd-standard"
      size  = var.disk_size
    }
  }
  tags = ["${var.group_name}-master"]

  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnetwork.name
    access_config {
      nat_ip = google_compute_address.master.address
    }
  }

  metadata = {
    "ssh-keys" : var.ssh_key
  }
  metadata_startup_script = data.template_file.master.rendered
}
