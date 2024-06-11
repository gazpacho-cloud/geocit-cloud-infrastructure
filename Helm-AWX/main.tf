terraform {
  backend "gcs" {
    bucket = "ferrous-terrain-422816-terraform-state"
    prefix = "terraform/state"
  }
  required_version = "~> 1.7.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.32.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

data "google_client_config" "default" {}

data "google_container_cluster" "awx_cluster" {
  name     = "super-awesome-cluster"
  location = "europe-west3"
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.awx_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.awx_cluster.master_auth[0].cluster_ca_certificate)

  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*"
  ]
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.awx_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.awx_cluster.master_auth[0].cluster_ca_certificate)
  }
}

provider "kubectl" {
  host                   = "https://${data.google_container_cluster.awx_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.awx_cluster.master_auth[0].cluster_ca_certificate)
  load_config_file       = false
}

