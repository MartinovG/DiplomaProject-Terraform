data "google_client_config" "default" {}

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