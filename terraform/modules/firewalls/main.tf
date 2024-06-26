resource "google_compute_firewall" "fw1" {

  name = "website-fw-1"
  network = var.network
  source_ranges = ["10.10.10.0/24","10.10.20.0/24","10.10.0.0/24","11.11.0.0/24"]
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
  network = var.network
  source_ranges = ["10.10.0.0/24"]
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
  network = var.network
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
    ports = ["22","443"]
  }
  target_tags = ["load-balanced-backend"]
  direction = "INGRESS"
}


resource "google_compute_firewall" "rules" {
  name    = "allow-ssh"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["91.224.69.0/24","46.200.235.0/24", "35.235.240.0/20"]
}
resource "google_compute_firewall" "allow_connect_to_db" {
  name    = "allow-connect-to-db"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "db1" {
  name    = "db1"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "target_grafane" {

  name = "website-grafane"
  network = var.network
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["443","22","8081","8082"]
  }

  target_tags = ["allow-all"]
}
