terraform {
    backend "gcs" {
      bucket      = "dp-gcp-migration-tf-state"
      prefix      = "europe-west1/container-registry.tfstate"
    }
}