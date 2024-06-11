provider "google" {
  credentials = file("${path.module}/../ferrous-terrain-422816-i0-b0707ebf99c4.json")
  project     = var.project
  region      = var.region
}

data "google_client_config" "default" {}
