variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "aws_region" {
  description = "AWS Region for the ACK controller to manage resources in."
  type        = string
}

variable "cluster_identity_oidc_issuer_url" {
  description = "The OIDC issuer URL for the EKS cluster."
  type        = string
}

variable "cluster_identity_oidc_issuer_arn" {
  description = "The OIDC issuer ARN for the EKS cluster."
  type        = string
}

variable "helm_release_name" {
}

variable "helm_repo_url" {
}

variable "helm_chart_name" {
}

variable "k8s_namespace" {
  description = "The Kubernetes namespace to deploy the ACK Controller."
  default     = "ack-system"
  type        = string
}

variable "k8s_service_account_name" {
  description = "The name of the Kubernetes service account for the ACK Controller."
  default     = "ack-rds-controller"
  type        = string
}

variable "helm_chart_version" {
  description = "Helm chart version."
  default     = "v1.1.0"
  type        = string
}