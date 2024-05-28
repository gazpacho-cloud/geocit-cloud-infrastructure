# Load balancer IP
resource "google_compute_global_address" "lb_ip_address" {
  name        = "example-lb-ip"
  description = "Public IP address of the Global HTTPS load balancer"
}

# https proxy
resource "google_compute_target_https_proxy" "https_proxy" {
  name     = "https-webserver-proxy"
  description     = "HTTPS Proxy mapping for the Load balancer including wildcard ssl certificate"
  url_map  = google_compute_url_map.url_map.self_link
  certificate_map = "//${google_project_service.certificate_manager.service}/${google_certificate_manager_certificate_map.certificate_map.id}"
}

#/Load Balancer/--------------------
/* resource "google_compute_global_address" "default" {
  name     = "globaladdress"
} */
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "https-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.https_proxy.self_link
  ip_address            = google_compute_global_address.lb_ip_address.id
}


# HTTP proxy
resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name        = "http-forwarding-rule"
  description = "Global external load balancer HTTP redirect"
  ip_address  = google_compute_global_address.lb_ip_address.id
  port_range  = "80"
  target      = google_compute_target_http_proxy.http_proxy.self_link
}

# Default URL map
resource "google_compute_url_map" "url_map" {
  name        = "url-map"
  description = "Url mapping to the backend services"
  default_service = google_compute_backend_service.default.id
}

## HTTPS redirect proxy
resource "google_compute_target_http_proxy" "http_proxy" {
  name        = "http-webserver-proxy"
  description = "Redirect proxy mapping for the Load balancer"
  url_map     = google_compute_url_map.http_https_redirect.self_link
}

# Redirect URL map
resource "google_compute_url_map" "http_https_redirect" {
  name        = "http-https-redirect"
  description = "HTTP Redirect map"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
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
## Enable the Cloud DNS API ##
resource "google_project_service" "cloud_dns" {
  service = "dns.googleapis.com"
}

## Public Cloud DNS zone. Make sure to configure your domain under Google Domains to use Cloud DNS ##
resource "google_dns_managed_zone" "public_dns_zone" {
  name        = "public-dns-zone"
  dns_name    = "theranodocker.buzz."
  description = "Public DNS zone for theranodocker.buzz"

/*   lifecycle {
    prevent_destroy = true
  } */
}

## Certificate manager resources to provision a wildcard SSL certificate for a Load Balancer. Requires a Public DNS zone ##
## Global load balancer DNS records ##
resource "google_dns_record_set" "global_load_balancer_sub_domain" {
  managed_zone = google_dns_managed_zone.public_dns_zone.name
  name         = "*.${google_dns_managed_zone.public_dns_zone.dns_name}"
  type         = "A"
  rrdatas      = [google_compute_global_address.lb_ip_address.address]
}

resource "google_dns_record_set" "global_load_balancer_top_level_domain" {
  managed_zone = google_dns_managed_zone.public_dns_zone.name
  name         = google_dns_managed_zone.public_dns_zone.dns_name
  type         = "A"
  rrdatas      = [google_compute_global_address.lb_ip_address.address]
}

## Enable the certificate manager API ##
resource "google_project_service" "certificate_manager" {
  service = "certificatemanager.googleapis.com"
}

## Configure DNS authorization to provide the ACME challenge DNS records ##
resource "google_certificate_manager_dns_authorization" "dns_authorization" {
  name        = "dns-authorization"
  description = "DNS authorization for theranodocker.buzz to support wildcard certificates"
  domain      = "theranodocker.buzz"
}

## Provision a wildcard managed SSL certificate using DNS authorization ##
resource "google_certificate_manager_certificate" "wildcard_ssl_certificate" {
  name        = "wildcard-ssl-certificate"
  description = "Wildcard certificate for theranodocker.buzz and sub-domains"

  managed {
    domains = ["theranodocker.buzz", "*.theranodocker.buzz"]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.dns_authorization.id
    ]
  }
}

## Certificate map resource to reference to from a forwarding rule ##
resource "google_certificate_manager_certificate_map" "certificate_map" {
  name        = "certificate-map"
  description = "theranodocker.buzz certificate map containing the domain names and sub-domains names for the SSL certificate"
}

## Certificate map entry for the top-level domain ##
resource "google_certificate_manager_certificate_map_entry" "domain_certificate_entry" {
  name         = "domain-cert-entry"
  description  = "theranodocker.buzz certificate entry"
  map          = google_certificate_manager_certificate_map.certificate_map.name
  certificates = [google_certificate_manager_certificate.wildcard_ssl_certificate.id]
  hostname     = "theranodocker.buzz"
}

## Certificate map entry for the sub domain
resource "google_certificate_manager_certificate_map_entry" "sub_domain_certificate_entry" {
  name         = "sub-domain-entry"
  description  = "*.theranodocker.buzz certificate entry"
  map          = google_certificate_manager_certificate_map.certificate_map.name
  certificates = [google_certificate_manager_certificate.wildcard_ssl_certificate.id]
  hostname     = "*.theranodocker.buzz"
}

## DNS authorization record ##
resource "google_dns_record_set" "dns_authorization_wildcard_certificate" {
  name         = google_certificate_manager_dns_authorization.dns_authorization.dns_resource_record[0].name
  managed_zone = google_dns_managed_zone.public_dns_zone.name
  type         = google_certificate_manager_dns_authorization.dns_authorization.dns_resource_record[0].type
  ttl          = 300
  rrdatas      = [google_certificate_manager_dns_authorization.dns_authorization.dns_resource_record[0].data]
}