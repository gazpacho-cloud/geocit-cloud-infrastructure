resource "google_compute_instance" "Instance_for_grafane" {
  count        = 1
  name         = "instance-for-grafane"
  machine_type = "e2-small"
  #треба описати A list of network tags to attach to the instance.
  #tags = ["ssh-enabled", "bar"]
  tags =["allow-all"]
  # metadata             = {
  #         - "ssh-keys" ={}
  # }
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
