provider "google" {
  credentials = file("${path.module}/../you-json-key.json")
  project     = var.project
  region      = var.region
}

data "google_client_config" "default" {}
