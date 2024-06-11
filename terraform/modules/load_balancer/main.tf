resource "google_compute_global_forwarding_rule" "default" {
  name                  = "app-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.load_b_https.id
  ip_address            = var.global_address
}

# http proxy
resource "google_compute_target_https_proxy" "load_b_https" {
  name     = "app-target-http-proxy"
  url_map  = google_compute_url_map.default.id
   ssl_certificates = [google_compute_ssl_certificate.certs.self_link]
}

# url map
resource "google_compute_url_map" "default" {
  name            = "app-url-map"

  default_service = google_compute_backend_service.default.id
}

# backend service with custom request and response headers
resource "google_compute_backend_service" "default" {
  name                    = "app-backend-service"
  protocol                = "HTTP"
  port_name               = "my-port"
  load_balancing_scheme   = "EXTERNAL"
  session_affinity      = "GENERATED_COOKIE"

  timeout_sec             = 10
  enable_cdn              = true
  health_checks           = [google_compute_health_check.default.id]
  backend {
    group           = google_compute_instance_group_manager.default.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

