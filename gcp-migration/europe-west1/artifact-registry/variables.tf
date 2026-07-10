variable "project_id" {
    description = "GCP project ID"
    default     = "playground-s-11-fc8b3fbb"
}

variable "region" {
    description = "GCP region"
    default     = "europe-west1"
}

variable "format" {
    description = "Artifact Registry format"
    default     = "DOCKER"
}

variable "github_owner" {
    type        = string
    default    = "MartinovG"
}

variable "github_repositories" {
    type        = set(string)
    default     = [
        "MartinovG/DiplomaProject-Terraform",
        "MartinovG/DiplomaProject-App",
        "MartinovG/DiplomaProject-ArgoCD"
    ]
}