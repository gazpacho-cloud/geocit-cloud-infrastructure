resource "google_compute_forwarding_rule" "default" {

  depends_on = [google_compute_subnetwork.proxy]
  name   = "website-forwarding-rule"


  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.default.id
  network               = google_compute_network.static.id
  subnetwork            = google_compute_subnetwork.my_custom_subnet.id
}

resource "google_compute_region_target_http_proxy" "default" {



  name    = "website-proxy"
  url_map = google_compute_region_url_map.default.id
}
resource "google_compute_region_url_map" "default" {



  name            = "website-map"
  default_service = google_compute_region_backend_service.default.id
}
resource "google_compute_region_backend_service" "default" {


  load_balancing_scheme = "INTERNAL_MANAGED"

  backend {
    group = google_compute_region_instance_group_manager.rigm.instance_group
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }

  name        = "website-backend"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_region_health_check.default.id]
}
resource "google_compute_region_instance_group_manager" "rigm" {
  name     = "website-rigm"
  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
  base_instance_name = "internal-glb"
  target_size        = 1
}
resource "google_compute_region_health_check" "default" {
  depends_on = [google_compute_firewall.fw4]

  name   = "website-hc"
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}
