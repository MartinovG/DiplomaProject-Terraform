variable "region" {
    default = "europe-west1"
}

variable "project_id" {
    description = "GCP project ID"
    default     = "playground-s-11-6957cfc9"
}

variable "vpc_name" {
    description = "Name of the VPC"
    default     = "dp-gcp-migration-vpc"
}