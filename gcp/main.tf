terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.9.0"
    }
  }
}

provider "google" {
  credentials = file("~/keys/gcp-terraform-default-service-account.json")
  project     = "terraform-338309"
  region      = "asia-southeast1"
  zone        = "asia-southeast1-b"
}

# Create a Compute Engine instance
resource "google_compute_instance" "app_server" {
  name         = "compute-engine-1"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}

# Create a SQL Database instance
resource "google_sql_database_instance" "db_server" {
  name             = "master"
  database_version = "POSTGRES_12"

  settings {
    tier = "db-f1-micro"
  }
}