variable "project_id" {
    description = "GCP project ID"
    default     = "playground-s-11-6957cfc9"
}

variable "region" {
    description = "GCP region"
    default     = "europe-west1"
}

variable "format" {
    description = "Artifact Registry format"
    default     = "DOCKER"
}

variable "repository_ids" {
    description = "Artifact Registry repository IDs"
    type        = set(string)
    default     = [
        "dp-gcp-migration-artifact-registry-frontend",
        "dp-gcp-migration-artifact-registry-api"
        ]
}
