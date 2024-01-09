provider "google" {
  credentials = file("${var.GOOGLE_CREDENTIALS_JSON_PATH}")
  region      = var.GOOGLE_COMPUTE_REGION
  project     = var.GOOGLE_PROJECT_ID
}

resource "google_compute_network" "default" {
  name                    = "${var.GOOGLE_PROJECT_ID}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name                     = "${var.GOOGLE_PROJECT_ID}-subnetwork"
  ip_cidr_range            = var.cidr
  network                  = google_compute_network.default.self_link
  region                   = var.GOOGLE_COMPUTE_REGION
  private_ip_google_access = true
}

resource "google_container_cluster" "default" {
  name                     = "${var.GOOGLE_PROJECT_ID}-cluster"
  location                 = var.GOOGLE_COMPUTE_ZONE
  network                  = google_compute_network.default.name
  subnetwork               = google_compute_subnetwork.default.name
  remove_default_node_pool = true
  initial_node_count       = 0

  enable_legacy_abac = true

  master_auth {
    username = var.k8s_username
    password = var.k8s_password
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var.GOOGLE_PROJECT_ID}-node-pool"
  location   = var.GOOGLE_COMPUTE_ZONE
  cluster    = google_container_cluster.default.name
  node_count = var.node_count

  node_config {
    preemptible  = true
    machine_type = var.machine_type
    disk_size_gb = 10
    disk_type    = "pd-standard"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
