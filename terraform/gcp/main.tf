terraform {
  required_version = "1.6.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.10.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.10.0"
    }
  }
  backend "gcs" {
    prefix = ""
  }
}

provider "google" {
  project = var.project
  region  = "asia-northeast1"
}

provider "google-beta" {
  project = var.project
  region  = "asia-northeast1"
}

module "github_actions" {
  source              = "../modules/gcp/workload-identity/github-actions"
  project             = var.project
  attribute_condition = "attribute.repository==\"tetsuya28/samples\""
  github_actions_roles = [
    "roles/clouddeploy.serviceAgent",
    "roles/clouddeploy.releaser",
    "roles/cloudbuild.serviceAgent", // storage.buckets.list
    "roles/clouddeploy.operator", // clouddeploy.deliveryPipelines.update
  ]
}
