locals {
  argocd_hostname = "argocd-gmdiplomaproject.elsys.itgix.eu" 
  
  argocd_values = {
    configs = {
      params = {
        "server.insecure"        = true
        "application.namespaces" = "*"
      }
    }
    
    server = {
      ingress = {
        enabled          = true
        ingressClassName = "alb"
        hostname         = local.argocd_hostname
        annotations = {
          "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
          "alb.ingress.kubernetes.io/target-type"      = "ip"
          "alb.ingress.kubernetes.io/healthcheck-path" = "/"
          "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
          "external-dns.alpha.kubernetes.io/hostname"  = local.argocd_hostname
          "alb.ingress.kubernetes.io/listen-ports"     = jsonencode([{ "HTTP" = 80 }, { "HTTPS" = 443 }])
          "alb.ingress.kubernetes.io/ssl-redirect"     = "443"
          "alb.ingress.kubernetes.io/certificate-arn"  = data.aws_acm_certificate.argo.arn
        }
        tls = [{
          hosts = [local.argocd_hostname]
        }]
      }
      resources = {
        requests = { cpu = "50m", memory = "64Mi" }
        limits   = { cpu = "200m", memory = "256Mi" }
      }
    }
    
    controller = {
      resources = {
        requests = { cpu = "50m", memory = "64Mi" }
        limits   = { cpu = "500m", memory = "512Mi" }
      }
    }
    
    redis = {
      resources = {
        requests = { cpu = "50m", memory = "64Mi" }
        limits   = { cpu = "100m", memory = "128Mi" }
      }
    }
  }
}

resource "helm_release" "argocd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.3.4" 
  namespace        = "argocd"
  create_namespace = true
  cleanup_on_fail  = true

  depends_on = [
    module.eks,
    module.alb_controller 
  ]

  values = [yamlencode(local.argocd_values)]
}