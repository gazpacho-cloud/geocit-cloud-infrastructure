
module "autoscaling_instances" {
  source     = "./modules/autoscaling_instances"
  network    = google_compute_network.static.id
  subnetwork = google_compute_subnetwork.sub_for_instances.id

}

module "compute_instance" {
  source     = "./modules/compute_instance"
  network    = google_compute_network.static.id
  subnetwork = google_compute_subnetwork.my_custom_subnet_for_grafane1.id
}

module "psql_db" {
  source  = "./modules/psql_db"
  network = google_compute_network.static.id
  #vpc_peering_to_db = google_service_networking_connection.private_vpc_connection.id
  subnetwork = google_compute_subnetwork.my_custom_subnet_for_postgres.id
}

module "dns" {
  source         = "./modules/dns"
  global_address = google_compute_global_address.static.address

}
module "firewalls" {
  source  = "./modules/firewalls"
  network = google_compute_network.static.name
}

module "load_balancer" {
  source            = "./modules/load_balancer"
  instance_template = module.autoscaling_instances.instance_template
  global_address    = google_compute_global_address.static.id

}
module "compute_instance_for_jfrog" {
  source     = "./modules/compute_instance_for_jfrog"
  network    = google_compute_network.static.id
  subnetwork = google_compute_subnetwork.my_custom_subnet_for_grafane1.id
}

module "nat" {
  source = "./modules/nat"
}
