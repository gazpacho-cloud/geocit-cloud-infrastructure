resource "google_compute_instance_template" "default" {
  name           = "my-instance-template"
  machine_type   = "e2-small"
  can_ip_forward = false

  tags = ["allow-ssh", "load-balanced-backend","allow-health-check"]

  disk {
    source_image = data.google_compute_image.ubuntu2204.id
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = var.network
    subnetwork = var.subnetwork
  }
}

data "google_compute_image" "ubuntu2204" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

