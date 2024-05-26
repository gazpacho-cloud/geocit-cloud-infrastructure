
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


resource "google_compute_firewall" "rules" {
  name    = "allow-ssh"
  network = "my-network" 

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "allow_connect_to_db" {
  name    = "allow-connect-to-db"
  network = "my-network" 

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "db1" {
  name    = "db1"
  network = "my-network" 

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "fw7" {

  name = "website-fw-7"
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

}
# allow access from health check ranges
resource "google_compute_firewall" "default" {
  name          = "app-fw-allow-hc"
  direction     = "INGRESS"
  network       = google_compute_network.static.id
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}