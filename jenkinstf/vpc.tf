resource "google_compute_network" "static" {
  name                            = "jenkins-network"
  auto_create_subnetworks         = false
}
resource "google_compute_subnetwork" "sub_for_instances" {
  name          = "jenkins-subnet"
  ip_cidr_range = "11.11.0.0/24"
  network       = google_compute_network.static.name
}
resource "google_compute_firewall" "target_grafane" {

  name = "website-jenkins"
  network = google_compute_network.static.id
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }
  direction = "EGRESS"
}
resource "google_compute_firewall" "target_jenkins" {

  name = "website-jenkins1"
  network = google_compute_network.static.id
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }

}
resource "google_compute_network_peering" "static" {
  name         = "peering1"
  network      = "${google_compute_network.static.self_link}"
  peer_network = "projects/${var.gcp_project}/global/networks/my-network"
}
resource "google_compute_network_peering" "static1" {
  name         = "peering2"
  network      = "projects/${var.gcp_project}/global/networks/my-network"
  peer_network = "${google_compute_network.static.self_link}"

  import_subnet_routes_with_public_ip = true
}
