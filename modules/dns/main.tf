data "google_dns_managed_zone" "gazpacho" {
  name = "gazpacho"


  
}

# to register web-server's ip address in DNS
resource "google_dns_record_set" "default" {
  name         = data.google_dns_managed_zone.gazpacho.dns_name
  managed_zone = data.google_dns_managed_zone.gazpacho.name
  type         = "A"
  ttl          = 300
  rrdatas = [var.global_address]
}