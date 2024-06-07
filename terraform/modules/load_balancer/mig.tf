resource "google_compute_instance_group_manager" "default" {
  name     = "app-mig1"

  named_port {
    name = "my-port"
    port = 8080
  }
  version {
    instance_template = var.instance_template
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