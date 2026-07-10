provider "google" {
  project = var.project_id
  region = var.region
}

module "gateway_ip" {
  source = "terraform-google-modules/address/google"
  version = "~> 5.0"

  project_id = var.project_id
  region     = var.region

  global = true
  address_type = "EXTERNAL"
  names       = ["gm-dp-gateway-ip"]
}