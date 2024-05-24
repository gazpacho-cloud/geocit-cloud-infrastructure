resource "google_compute_instance" "apps1" {
  provider = google
  count        = 1
  name         = "apps-${count.index + 1}"
  machine_type = "e2-small"
  #треба описати A list of network tags to attach to the instance.
  #tags = ["ssh-enabled", "bar"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      
      

    }
  }
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}







