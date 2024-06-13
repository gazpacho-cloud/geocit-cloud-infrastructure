resource "kubernetes_namespace" "awx" {
  metadata {
    name = "awx-namespace"
  }
  timeouts {
    delete = "1m"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
  timeouts {
    delete = "1m"
  }
}

resource "kubectl_manifest" "awx_instance" {
  yaml_body = <<YAML
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: ansible-awx
  namespace: ${kubernetes_namespace.awx.metadata[0].name}
spec:
  service_type: nodeport
  admin_user: ${var.awx_admin_username}
  admin_password_secret: ${kubernetes_secret.awx_admin_password.metadata[0].name}
  postgres_storage_class: ${var.storage_class}
  postgres_data_volume_init: true
YAML
}

resource "kubernetes_service" "awx_service" {
  metadata {
    name      = "awx-service"
    namespace = kubernetes_namespace.awx.metadata[0].name
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "ansible-awx-web"
    }
    port {
      port        = 8052
      target_port = 8052
      protocol    = "TCP"
    }
    type = "LoadBalancer"
  }
  depends_on = [kubectl_manifest.awx_instance]
}
