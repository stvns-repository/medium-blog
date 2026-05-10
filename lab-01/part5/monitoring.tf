resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.monitoring_namespace
  }
}

resource "helm_release" "prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.id
  version    = var.prometheus_version
set = [
    {
      name  = "grafana.service.type"
      value = "LoadBalancer"
    },
    {
      name  = "grafana.adminPassword"
      value = var.grafana_admin_password
    }
  ]
}
