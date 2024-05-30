resource "google_sql_database_instance" "postgres" {
  name             = "postgres-instance-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_14"
  deletion_protection = false
  depends_on = [var.vpc_peering_to_db]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network
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
#testuser
resource "google_sql_user" "db_user" {
  name     = "postgres"
  instance = google_sql_database_instance.postgres.name
  password = "postgres"
}
resource "random_id" "db_name_suffix" {
  byte_length = 4
}