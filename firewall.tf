
resource "google_compute_firewall" "fw1" {

  name = "website-fw-1"
  network = google_compute_network.static.id
  source_ranges = ["10.10.0.0/24"]
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }
  direction = "INGRESS"
}
resource "google_compute_firewall" "fw2" {
  depends_on = [google_compute_firewall.fw1]
  name = "website-fw-2"
  network = google_compute_network.static.id
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  target_tags = ["allow-ssh"]
  direction = "INGRESS"
}

resource "google_compute_firewall" "fw3" {
  depends_on = [google_compute_firewall.fw2]

  name = "website-fw-3"
  network = google_compute_network.static.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["load-balanced-backend"]
  direction = "INGRESS"
}

resource "google_compute_firewall" "fw4" {
  depends_on = [google_compute_firewall.fw3]

  name = "website-fw-4"
  network = google_compute_network.static.id
  source_ranges = ["10.129.0.0/26"]
  target_tags = ["load-balanced-backend"]
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  allow {
    protocol = "tcp"
    ports = ["443"]
  }
  allow {
    protocol = "tcp"
    ports = ["8000"]
  }

  direction = "INGRESS"
}
resource "google_compute_firewall" "rules" {
  name    = "allow-ssh"
  network = "my-network" 

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}
