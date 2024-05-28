#/Load Balancer/--------------------
resource "google_compute_global_address" "default" {
  name     = "globaladdress"
}
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "app-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

# http proxy
resource "google_compute_target_http_proxy" "default" {
  name     = "app-target-http-proxy"
  url_map  = google_compute_url_map.default.id
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
  timeout_sec             = 10
  enable_cdn              = true
  health_checks           = [google_compute_health_check.default.id]
  backend {
    group           = google_compute_instance_group_manager.default.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}
# health check
resource "google_compute_health_check" "default" {
  name     = "app-hc"

  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

# MIG
resource "google_compute_instance_group_manager" "default" {
  name     = "app-mig1"

  named_port {
    name = "my-port"
    port = 8080
  }
  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
  base_instance_name = "vm"
  target_size        = 1
}
#--------------------/

#autoscaling/------------------
resource "google_compute_autoscaler" "autoscaler" {
  name   = "app-autoscaler"
  target = google_compute_instance_group_manager.default.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 800

    cpu_utilization {
      target = 0.9
    }
  }
}
#------------------////