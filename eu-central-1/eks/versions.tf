terraform {
  required_version = "~> 1.13.4"  

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.23.0"
        }
        helm = {
            source  = "hashicorp/helm"
            version = "~> 2.12"
        }
    }
}