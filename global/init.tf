provider "aws" {
    region = var.region
}

terraform {
    backend "s3" {
      bucket         = "gm-diploma-project-tf-states"
      key            = "global/backend.tfstate"
      region         = "eu-central-1"
      dynamodb_table = "gm-diploma-project-tf-states-lock-table"
      encrypt        = true
    }
}