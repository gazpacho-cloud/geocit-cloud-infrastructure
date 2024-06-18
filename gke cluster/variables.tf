variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  default     = "europe-west3"
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster"
  default     = "super-awesome-cluster"
}

variable "machine_type" {
  description = "The machine type to use for the Kubernetes cluster nodes"
  default     = "e2-small"
}
