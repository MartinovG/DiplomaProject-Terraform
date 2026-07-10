terraform {
    backend "gcs" {
      bucket      = "dp-gc-migrations-tf-state-2"
      prefix      = "europe-west1/container-registry.tfstate"
    }
}