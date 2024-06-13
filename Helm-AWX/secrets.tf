resource "random_password" "awx_password" {
  length  = 16
  special = true
}

resource "google_secret_manager_secret" "awx_credentials" {
  secret_id = "awx-credentials"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "awx_password_version" {
  secret      = google_secret_manager_secret.awx_credentials.id
  secret_data = random_password.awx_password.result
}

resource "kubernetes_secret" "awx_admin_password" {
  metadata {
    name      = "awx-admin-password"
    namespace = kubernetes_namespace.awx.metadata[0].name
  }

  data = {
    password = google_secret_manager_secret_version.awx_password_version.secret_data
  }
}
