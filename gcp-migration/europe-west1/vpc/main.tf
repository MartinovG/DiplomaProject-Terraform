provider "google" {
    project = var.project_id    
    region = var.region
}

module "vpc" {
    source = "terraform-google-modules/network/google"
    version = "~> 18.1"

    project_id = var.project_id
    network_name = var.vpc_name
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name   = "gm-dp-migration"
            subnet_ip     = "10.0.0.0/16"
            subnet_region = var.region
            subnet_private_access = true
        }
    ]

    secondary_ranges = {
        gm-dp-migration = [
            {
                range_name    = "gke-pods"
                ip_cidr_range = "10.1.0.0/24"
            },
            {
                range_name    = "gke-services"
                ip_cidr_range = "10.2.0.0/24"
            }
        ]
    }
}