resource "google_compute_instance" "instance_for_postgres" {
  count        = 1
  name         = "instance-for-postgres"
  machine_type = "e2-small"
  tags         = ["allow-all"]
  #depends_on   = [var.vpc_peering_to_db]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = var.network
    subnetwork = var.subnetwork
    access_config {
      // Ephemeral public IP
      
    }
  }
}
#testuser
#resource "google_sql_user" "db_user" {
  #name     = "postgres"
 # instance = google_sql_database_instance.postgres.name
 ### password = "postgres"
#}
#resource "random_id" "db_name_suffix" {
  #byte_length = 4
#}