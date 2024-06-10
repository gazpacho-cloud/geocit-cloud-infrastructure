resource "google_compute_network" "static" {
  name                    = "my-network"
  auto_create_subnetworks = false
}
resource "time_sleep" "wait_120_seconds" {
  depends_on      = [google_compute_network.static]
  create_duration = "120s"
}

# This resource will create (at least) 30 seconds after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_120_seconds]
}

resource "google_compute_global_address" "static" {
  depends_on = [time_sleep.wait_120_seconds]
  name       = "globaladdress"
}

resource "google_compute_subnetwork" "sub_for_instances" {
  depends_on    = [time_sleep.wait_120_seconds]
  name          = "my-custom-subnet"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.static.name
}

resource "google_compute_subnetwork" "my_custom_subnet_for_grafane1" {
  depends_on    = [time_sleep.wait_120_seconds]
  name          = "my-custom-subnet-for-grafane1"
  ip_cidr_range = "10.10.10.0/24"
  network       = google_compute_network.static.name
}

resource "google_compute_subnetwork" "my_custom_subnet_for_postgres" {
  depends_on    = [time_sleep.wait_120_seconds]
  name          = "my-custom-subnet-for-postgres"
  ip_cidr_range = "10.10.20.0/24"
  network       = google_compute_network.static.name
}

