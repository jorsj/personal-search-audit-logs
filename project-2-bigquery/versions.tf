terraform {
  required_version = ">= 1.9"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.41"
    }
  }
}

provider "google" {
  project               = var.bigquery_project_id
  user_project_override = true
  billing_project       = var.bigquery_project_id
}
