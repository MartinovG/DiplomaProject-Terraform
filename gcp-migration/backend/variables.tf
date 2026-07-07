variable "region" {
    default = "europe-west1"
}

variable "bucket_name" {
    description = "Name of S3 bucket"
    default    = "dp-gcp-migration-tf-state"
}

variable "project_id" {
    description = "GCP project ID"
    default     = "playground-s-11-6957cfc9"
}