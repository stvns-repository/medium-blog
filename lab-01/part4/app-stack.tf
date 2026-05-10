# 1. Define the Storage Class for EBS (Updated to v1)
resource "kubernetes_storage_class_v1" "ebs_sc" {
  metadata {
    name = "ebs-sc"
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"
}

# 2. This is for the PVC (Persistent Volume Claim)
resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name = "postgres-pvc"
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class_v1.ebs_sc.metadata[0].name
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
  wait_until_bound = false
}

# 3. Deploy postgres
resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "postgres"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }
      spec {
        security_context {
          fs_group = 999
        }
        container {
          name  = "postgres"
          image = "postgres:15"
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.db_password # References variables.tf
          }
          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
          }
          port {
            container_port = 5432
          }
          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
            sub_path   = "pgdata"
          }
        }
        volume {
          name = "postgres-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

# 4. The Flask Application
resource "kubernetes_deployment" "flask_app" {
  # This is to avoid the creation of the Flask App if the ECR Respository isn't existing yet (race condition).
  count = var.app_image == "placeholder" ? 0 : 1

  metadata {
    name = "flask-app"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "flask-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "flask-app"
        }
      }
      spec {
        container {
          name  = "flask-container"
          image = var.app_image
          port {
            container_port = 5000
          }
          env {
            name  = "DB_HOST"
            value = "postgres"
          }
          env {
            name  = "DB_PASS"
            value = var.db_password # References variables.tf
          }
          env {
            name  = "API_KEY"
            value = var.api_key     # References variables.tf
          }
        }
      }
    }
  }
}

# 5. The Load Balancer Service
resource "kubernetes_service" "nginx_lb" {
  count = var.app_image == "placeholder" ? 0 : 1

  metadata {
    name = "nginx-lb"
  }
  spec {
    selector = {
      app = "flask-app"
    }
    port {
      port        = 80
      target_port = 5000
    }
    type = "LoadBalancer"
  }
}

# 6. The ClusterIP for postgres
resource "kubernetes_service" "postgres_svc" {
  metadata {
    name      = "postgres"
    namespace = "default"
  }
  spec {
    selector = {
      app = "postgres"
    }
    port {
      port        = 5432
      target_port = 5432
    }
    type = "ClusterIP"
  }
}
