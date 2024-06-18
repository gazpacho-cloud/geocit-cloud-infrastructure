resource "google_compute_instance" "Instance_for_grafane" {
  count        = 1
  name         = "instance-jenkins"
  machine_type = "e2-small"
  #треба описати A list of network tags to attach to the instance.
  #tags = ["ssh-enabled", "bar"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = google_compute_network.static.id
    subnetwork = google_compute_subnetwork.sub_for_instances.id
    access_config {
      // Ephemeral public IP      
    }
  }
}
