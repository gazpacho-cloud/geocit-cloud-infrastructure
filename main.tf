resource "google_compute_instance" "Instance_for_grafane" {
  provider = google
  count        = 1
  name         = "instance-for-grafane"
  machine_type = "e2-small"
  #треба описати A list of network tags to attach to the instance.
  #tags = ["ssh-enabled", "bar"]
  tags =["allow-all"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "my-network"
    subnetwork = google_compute_subnetwork.my_custom_subnet_for_grafane1.id
    access_config {
      // Ephemeral public IP
      
    }


  }
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

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
    network = google_compute_network.static.id
    subnetwork = google_compute_subnetwork.my_custom_subnet.name
  }



}


data "google_compute_image" "ubuntu2204" {


  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}









