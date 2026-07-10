variable "project_id" {
    description = "GCP project ID"
    type     = string
}

variable "region" {
    default = "europe-west1"
}

variable "cluster_name" {
    description = "GKE cluster name"
    default     = "dp-gcp-migration-gke"
}


