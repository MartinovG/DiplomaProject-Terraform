variable "project_id" {
    description = "GCP project ID"
    default     = "playground-s-11-a2f0baaf"
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
        "DiplomaProject-Terraform",
        "DiplomaProject-App",
        "DiplomaProject-ArgoCD"
    ]
}