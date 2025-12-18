locals {
  grafana_hostname = "grafana-gmdiplomaproject.elsys.itgix.eu"

  kube_prometheus_stack_values = {
    grafana = {
      ingress = {
        enabled          = true
        ingressClassName = "alb"
        hosts            = [local.grafana_hostname]
        
        annotations = {
          "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
          "alb.ingress.kubernetes.io/target-type"      = "ip"
          "alb.ingress.kubernetes.io/healthcheck-path" = "/api/health"
          "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"

          "external-dns.alpha.kubernetes.io/hostname" = local.grafana_hostname
          
          "alb.ingress.kubernetes.io/certificate-arn" = data.aws_acm_certificate.grafana.arn
          "alb.ingress.kubernetes.io/listen-ports"    = jsonencode([{ "HTTP" = 80 }, { "HTTPS" = 443 }])
          "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
        }
      }

      persistence = {
        enabled = true 
        storageClassName = "gp3"
        size = "10Gi"
        accessMode = ["ReadWriteOnce"]
    }
      
      "grafana.ini" = {
        server = {
          root_url = "https://${local.grafana_hostname}"
        }
        unified_alerting = { enabled = true }
        alerting         = { enabled = false }
      }
    }

    prometheus = {
      prometheusSpec = {
        storageSpec = {
          volumeClaimTemplate = {
            spec = {
              storageClassName = "gp3"
              accessModes = ["ReadWriteOnce"]
              resources = {
                requests = {
                  storage = "20Gi"
                }
              }
            }
          }
        } 
      }
    }
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
  cleanup_on_fail  = true

  values = [
    yamlencode(local.kube_prometheus_stack_values)
  ]

  depends_on = [module.eks]
}