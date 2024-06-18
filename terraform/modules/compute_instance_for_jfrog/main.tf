resource "google_compute_instance" "Instance_for_jfrog" {
  count        = 1
  name         = "instance-for-jfrog"
  machine_type = "e2-medium"
  #треба описати A list of network tags to attach to the instance.
  #tags = ["ssh-enabled", "bar"]
  tags =["allow-all"]
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
