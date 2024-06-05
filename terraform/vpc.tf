resource "google_compute_network" "static" {
  name                            = "my-network"
  delete_default_routes_on_create = true
  auto_create_subnetworks         = false
}

resource "google_compute_global_address" "default" {
  name = "globaladdress"
}

resource "google_compute_subnetwork" "sub_for_instances" {
  name          = "my-custom-subnet"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.static.name
}

resource "google_compute_subnetwork" "my_custom_subnet_for_grafane1" {
  name          = "my-custom-subnet-for-grafane1"
  ip_cidr_range = "10.10.10.0/24"
  network       = google_compute_network.static.name
}

resource "google_compute_subnetwork" "my_custom_subnet_for_postgres" {
  name          = "my-custom-subnet-for-postgres"
  ip_cidr_range = "10.10.20.0/24"
  network       = google_compute_network.static.name
}


