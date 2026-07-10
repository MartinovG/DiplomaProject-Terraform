variable "region" {
    default = "europe-west1"
}

variable "project_id" {
    description = "GCP project ID"
    type     = string
}

variable "vpc_name" {
    description = "Name of the VPC"
    default     = "dp-gcp-migration-vpc"
}