terraform {
  required_version = "~> 0.14.8"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.60.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

resource "random_id" "cromwell_random_suffix" {
  byte_length = 4
}

resource "google_compute_network" "cromwell_network" {
    name           = "cromwell-network-${random_id.cromwell_random_suffix.hex}"    
}

resource "google_compute_firewall" "cromwell_firewall" {
  name    = "cromwell-${random_id.cromwell_random_suffix.hex}-ssh-firewall"
  network = google_compute_network.cromwell_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["cromwell-${random_id.cromwell_random_suffix.hex}-allow-ssh"]

}

# Allow http into that machine
resource "google_compute_firewall" "cromwell_http" {
  name    = "cromwell-${random_id.cromwell_random_suffix.hex}-http"
  network = google_compute_network.cromwell_network.name

  allow {
    protocol                 = "tcp"
    ports                    = ["8000"]
  }
 
  target_tags = ["cromwell-8000"]
}

resource "google_compute_instance" "cromwell" {
  name                    = "cromwell-${random_id.cromwell_random_suffix.hex}"
  machine_type            = var.cromwell_machine_config.machine_type
  tags                    = ["cromwell-8000", "cromwell-${random_id.cromwell_random_suffix.hex}-allow-ssh"]

  metadata_startup_script = templatefile("cromwell_provision.sh", 
    { 
      project_id = var.project_id,
      cromwell_bucket = "gs://${var.cromwell_bucket}",
      cromwell_db_name = var.cromwell_db_name,
      cromwell_db_user = var.cromwell_db_user,
      cromwell_db_password = var.cromwell_db_password
    }
  )

  boot_disk {
    initialize_params {
      image = var.cromwell_os_image
      size = var.cromwell_machine_config.disk_size_gb
    }
  }

  network_interface {
    network = google_compute_network.cromwell_network.name

    # This empty block allows us to get an IP
    access_config {
    }
  }

  service_account {
      email = var.service_account_email
      scopes = ["cloud-platform"]
  }

}
