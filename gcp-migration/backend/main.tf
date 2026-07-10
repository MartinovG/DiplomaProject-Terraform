provider "google" {
    project = var.project_id    
    region = var.region

}

resource "google_storage_bucket" "default" {
  name     = "${var.project_id}-tf-state"
  location = var.region
  force_destroy = true

  uniform_bucket_level_access = true
  public_access_prevention = "enforced"

  versioning {
    enabled = true
  }
}