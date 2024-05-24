resource "google_sql_database_instance" "postgres" {
  provider = google
  name             = "postgres-instance-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_14"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.static.id
    }

      }

    #   dynamic "authorized_networks" {
    #     for_each = local.onprem
    #     iterator = onprem

    #     content {
    #       name  = "onprem-${onprem.key}"
    #       value = onprem.value
    #     }
      #}
}
resource "google_sql_user" "db_user" {
  name     = "postgres"
  instance = google_sql_database_instance.postgres.name
  password = "postgres"
}