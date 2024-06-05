resource "google_compute_instance" "instance_for_postgres" {
  count        = 1
  name         = "instance-for-postgres"
  machine_type = "e2-small"
  tags         = ["allow-all"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = var.network
    subnetwork = var.subnetwork
    access_config {
      // Ephemeral public IP
      
    }
  }
}