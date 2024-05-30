resource "google_compute_health_check" "default" {
  name     = "app-hc"

  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}
