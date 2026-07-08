variable "region" {
    default = "europe-west1"
}

variable "bucket_name" {
    description = "Name of S3 bucket"
    default    = "dp-gc-migrations-tf-state"
}

variable "project_id" {
    description = "GCP project ID"
    default     = "playground-s-11-6cf436aa"
}