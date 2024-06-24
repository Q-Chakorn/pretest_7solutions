terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "google" {
  project = "<your-gcp-project-id>"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_network" "vpc_network" {
  name                    = "gke-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "gke-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_firewall" "gke_firewall" {
  name    = "gke-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "10250", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

output "endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "client_certificate" {
  value = google_container_cluster.primary.master_auth.0.client_certificate
}
