# Terraform configs and require provider plugins
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.9.0"
    }
  }
}

# Configure the Google Provider
provider "google" {
  credentials = file("~/keys/gcp-terraform-default-service-account.json")
  project     = "terraform-338309"
  region      = "asia-southeast1"
  zone        = "asia-southeast1-a"
}

# Create a Google Compute Engine instance
resource "google_compute_instance" "app_server" {
  name         = "app-server"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = var.image
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
  metadata_startup_script = file("./startup.sh")
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

# Create a Google Cloud SQL instance
resource "google_sql_database_instance" "db_server" {
  name                = "postgres-instance-${random_id.db_name_suffix.hex}"
  database_version    = "POSTGRES_11"
  deletion_protection = false
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      authorized_networks {
        value = "0.0.0.0/0"
        name  = "all"
      }
    }
  }
}

# Create a ProgreSQL user
resource "google_sql_user" "users" {
  instance = google_sql_database_instance.db_server.name
  name     = "root"
  password = "0604e2303aa2cc3c3"
}
