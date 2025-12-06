variable "k8s_namespace" {
  description = "Kubernetes namespace to deploy the AWS External DNS into."
  type        = string
  default     = "kube-system"
}

variable "k8s_replicas" {
  description = "Amount of replicas to be created."
  type        = number
  default     = 1
}

variable "k8s_pod_labels" {
  description = "Additional labels to be added to the Pods."
  type        = map(string)
  default     = {}
}

variable "helm_release_name" {
}

variable "helm_repo_url" {
}

variable "helm_chart_name" {
}

variable "helm_chart_version" {
}

variable "k8s_cluster_type" {
  description = "K8s cluster Type"
  type        = string
  default     = "eks"
}

variable "k8s_cluster_name" {
  description = "Current Cluster Name"
  type        = string
}

variable "domain_names_public" {
  description = "Route53 Domain Names"
  type        = list(string)
}

variable "domain_names_private" {
  description = "Route53 Domain Names"
  type        = list(string)
}

variable "cluster_identity_oidc_issuer_url" {
  type        = string
  description = "The OIDC Identity issuer for the cluster"
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
}

variable "deployment_service_account" {
  description = "Deployment Service Account in EKS cluster"
  type        = string
}

variable "settings" {}
variable "settings_list" {}