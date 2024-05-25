# resource "google_compute_instance" "apps1" {
#   provider = google
#   count        = 1
#   name         = "apps-${count.index + 1}"
#   machine_type = "e2-small"
#   #треба описати A list of network tags to attach to the instance.
#   #tags = ["ssh-enabled", "bar"]

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-2204-lts"
#     }
#   }

#   network_interface {
#     network = "default"

#     access_config {
      
      

#     }
#   }
# }

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_compute_autoscaler" "default" {

  name   = "my-autoscaler"
  target = google_compute_instance_group_manager.default.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60

  }
}

resource "google_compute_instance_template" "default" {


  name           = "my-instance-template"
  machine_type   = "e2-small"
  can_ip_forward = false

  tags = ["allow-ssh", "load-balanced-backend"]

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

resource "google_compute_target_pool" "default" {
  name = "my-target-pool"
}

resource "google_compute_instance_group_manager" "default" {

  name = "my-igm"

  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }

  target_pools       = [google_compute_target_pool.default.id]
  base_instance_name = "autoscaler-sample"
}

data "google_compute_image" "ubuntu2204" {


  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}










