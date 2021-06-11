/*
Default K3S using SQLite to storage cluster config. If you want to secure your 
cluster config, uncomment this file, or you can use your existed database.
Document reference: https://rancher.com/docs/k3s/latest/en/installation/datastore/
*/


/* resource "google_compute_global_address" "private_ip" {
  name          = "${var.group_name}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip.name]
}

resource "google_sql_database_instance" "storage" {
  name             = "${var.group_name}-db"
  database_version = "POSTGRES_11"
  region           = var.region

	depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_size         = 50
    disk_type         = "PD_SSD"
    disk_autoresize   = true

    ip_configuration {
      ipv4_enabled    = "false"
      private_network = google_compute_network.vpc.id
    }

    backup_configuration {
      enabled    = true
      start_time = "01:00"
    }

    maintenance_window {
      day  = 6
      hour = 1
    }
  }
}

resource "random_id" "default_password" {
  keepers = {
    name = google_sql_database_instance.storage.name
  }

  byte_length = 8
  depends_on  = [google_sql_database_instance.storage]
}

resource "google_sql_database" "default" {
  name       = "default"
  instance   = google_sql_database_instance.storage.name
  depends_on = [google_sql_database_instance.storage]
}

resource "google_sql_user" "storage" {
  name       = "du"
  instance   = google_sql_database_instance.storage.name
  password   = random_id.default_password.hex
  depends_on = [google_sql_database_instance.storage]
} */
