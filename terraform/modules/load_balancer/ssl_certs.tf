resource "google_compute_ssl_certificate" "certs" {
  name        = "ssl-certificate-load-balancer"
  private_key = file("private.key.pem")
  certificate = file("public.key.pem")
}
