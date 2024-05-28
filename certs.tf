
# resource "google_compute_region_ssl_certificate" "gazpacho" {
#   name        = "ssl-certificate"
#   private_key = file("./keys/private.key.pem")
#   certificate = file("./keys/intermediate.cert.pem")
# }

# #https/------------------
# resource "google_compute_region_target_https_proxy" "gazpacho" {
#   name             = "test-proxy"
#   url_map          = google_compute_url_map.default.id
#   ssl_certificates = [google_compute_region_ssl_certificate.gazpacho.id]
# }
#------------/////
data "google_dns_managed_zone" "gazpacho" {
  name = "gazpacho"


  
}

# to register web-server's ip address in DNS
resource "google_dns_record_set" "default" {
  name         = data.google_dns_managed_zone.gazpacho.dns_name
  managed_zone = data.google_dns_managed_zone.gazpacho.name
  type         = "A"
  ttl          = 300
  rrdatas = [google_compute_global_address.default.address]
}