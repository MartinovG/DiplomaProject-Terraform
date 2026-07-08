terraform {
    backend "gcs" {
      bucket      = "dp-gc-migrations-tf-state"
      prefix      = "europe-west1/gke.tfstate"
    }
}