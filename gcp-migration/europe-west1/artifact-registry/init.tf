terraform {
    backend "gcs" {
      bucket      = "dp-gc-migration-tf-state"
      prefix      = "europe-west1/container-registry.tfstate"
    }
}