resource "google_compute_network" "static" {
  name = "my-network"
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"

}

resource "google_compute_subnetwork" "my_custom_subnet" {
  name          = "my-custom-subnet"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.static.name

}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.static.id
}


resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.static.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges =  [google_compute_global_address.private_ip_alloc.name]
}


resource "google_compute_router" "router" {
  name    = "nat-router"
  network = "my-network"

}


resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
#create firewall rule for allowing connection to the vm with ssh


#sub for load balancer
resource "google_compute_subnetwork" "proxy" {

  name          = "website-net-proxy"
  ip_cidr_range = "10.129.0.0/26"
  network       = google_compute_network.static.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}