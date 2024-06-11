resource "helm_release" "awx_release" {
  name       = "awx-operator-release"
  repository = "https://ansible.github.io/awx-operator/"
  chart      = "awx-operator"
  namespace  = kubernetes_namespace.awx.metadata[0].name
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  values     = [
    file("${path.module}/prometheus-values.yaml")
  ]
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  values = [
    file("${path.module}/grafana-values.yaml")
  ]
}
