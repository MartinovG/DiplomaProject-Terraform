provider "google" {
    project = var.project_id    
    region = var.region

}

terraform {
  backend "gcs" {
    bucket      = "dp-gc-migrations-tf-state-2"
    prefix      = "global/backend.tfstate"
  }
}