provider "google" {
    project = var.project_id    
    region = var.region

}

terraform {
  backend "gcs" {
    bucket      = "dp-gc-migration-tf-state"
    prefix      = "global/backend.tfstate"
  }
}