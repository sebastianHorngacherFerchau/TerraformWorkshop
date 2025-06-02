terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.37.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.zone
}

resource "google_project_service" "iam" {
  project = var.project_id
  service = "iam.googleapis.com"
  timeouts {
    create = "20m"
    update = "20m"
  }
  disable_on_destroy = false
  disable_dependent_services = false
}


resource "google_project_service" "cloud_resource_manager" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"

  timeouts {
    create = "20m"
    update = "20m"
  }

  disable_on_destroy = false
  disable_dependent_services = false
}

