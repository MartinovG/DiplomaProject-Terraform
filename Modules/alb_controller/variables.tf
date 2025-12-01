variable "cluster_name" {
  description = "The name of the EKS cluster."
  type = string
}

variable "cluster_identity_oidc_issuer_arn" {
  description = "The OIDC issuer ARN for the EKS cluster."
  type = string
}

variable "cluster_identity_oidc_issuer_url" {
  description = "The OIDC issuer URL for the EKS cluster."
  type = string
}

variable "enabled" {
    type = bool
}

variable "helm_release_name" {
}

variable "helm_repo_url" {
}

variable "helm_chart_name" {
}

variable "helm_chart_version" {
}

variable "k8s_namespace" {
    description = "The Kubernetes namespace to deploy the ALB Ingress Controller."
    default = "alb-ingress"
}

variable "k8s_service_account_name" {
    description = "The name of the Kubernetes service account for the ALB Ingress Controller."
}

variable "mod_dependency" {
    description = "Module dependency to ensure proper resource creation order."
    default = null
}

variable "settings" {
    description = "Additional settings for the ALB Ingress Controller Helm chart."
    type = map(any)
    default = {}
}



