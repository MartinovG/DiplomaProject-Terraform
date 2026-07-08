locals {  
  argocd_values = {
    configs = {
      params = {
        "server.insecure"             = true
        "application.namespaces"      = "*"
        "controller.diff.server.side" = "true"
      }
    }
    
    server = {

        service = {
          type = "LoadBalancer"
        }

        resources = {
            requests = { cpu = "50m", memory = "64Mi" }
            limits   = { cpu = "200m", memory = "256Mi" }
        }
    }
    
    controller = {
      resources = {
        requests = { cpu = "50m", memory = "256Mi" }
        limits   = { cpu = "1", memory = "2Gi" }
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
  version          = "9.5.4"
  namespace        = "argocd"
  create_namespace = true
  cleanup_on_fail  = true

  depends_on = [
    module.gke 
  ]

  values = [yamlencode(local.argocd_values)]
}