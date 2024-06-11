
resource "google_compute_ssl_certificate" "certs" {
  name        = "ssl-certificate-load-balancer"
  private_key = file("key.pem")
  certificate = file("certificate.pem")
}
