

module "autoscaling_instances" {
  depends_on =[google_compute_network.static,time_sleep.wait_120_seconds]
  source     = "./modules/autoscaling_instances"
  network    = google_compute_network.static.id
  subnetwork = google_compute_subnetwork.sub_for_instances.id

}


module "compute_instance" {
  depends_on =[google_compute_network.static,time_sleep.wait_120_seconds]
  source     = "./modules/compute_instance"
  network    = google_compute_network.static.id
  subnetwork = google_compute_subnetwork.my_custom_subnet_for_grafane1.id
}


module "psql_db" {
  depends_on =[google_compute_network.static,time_sleep.wait_120_seconds]
  source  = "./modules/psql_db"
  network = google_compute_network.static.id
  #vpc_peering_to_db = google_service_networking_connection.private_vpc_connection.id
  subnetwork = google_compute_subnetwork.my_custom_subnet_for_postgres.id
}

module "dns" {
  depends_on =[google_compute_network.static,time_sleep.wait_120_seconds]
  source         = "./modules/dns"
  global_address = google_compute_global_address.static.address

}
module "firewalls" {
  depends_on =[google_compute_network.static,time_sleep.wait_120_seconds]
  source  = "./modules/firewalls"
  network = google_compute_network.static.id
}

module "load_balancer" {
  depends_on =[google_compute_network.static,time_sleep.wait_120_seconds]
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
  depends_on =[google_compute_network.static,time_sleep.wait_120_seconds]
  source = "./modules/nat"
}
