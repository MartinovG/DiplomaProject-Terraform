data "google_client_config" "default" {}
data "google_compute_default_service_account" "default_sa" {}

provider "google" {
    project = var.project_id    
    region = var.region
}

module "gke" {
    source = "terraform-google-modules/kubernetes-engine/google"
    version = "~> 44.3"

    project_id = var.project_id
    name       = var.cluster_name
    region     = var.region

    network = "dp-gcp-migration-vpc"
    subnetwork = "gm-dp-migration"

    ip_range_pods = "gke-pods"
    ip_range_services = "gke-services"

    create_service_account = false
    service_account = data.google_compute_default_service_account.default_sa.email

    deletion_protection = false

    node_pools = [
        {
            name         = "default-node-pool"
            machine_type = "e2-medium"
            min_count    = 1
            max_count    = 3
            preemptible  = true
        }
    ]
}