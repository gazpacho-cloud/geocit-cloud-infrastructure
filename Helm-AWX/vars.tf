variable "project" {
  description = "Project Id"
  default     = "ferrous-terrain-422816-i0"
}

variable "region" {
  description = "Region to deploy"
  default     = "europe-west3"
}

variable "zone" {
  description = "Zone to deploy"
  default     = "europe-west3-a"
}

variable "storage_class" {
  description = "Storage class name"
  default     = "premium-rwo"
}

variable "awx_admin_username" {
  description = "AWX admin username"
  default     = "admin"
}

variable "grafana_admin_username" {
  description = "Grafana admin username"
  default     = "admin"
}
