terraform {
    backend "s3" {
      bucket = "gm-diploma-project-tf-states"
      key = "eu-central-1/acm.tfstate"
      region = "eu-central-1"
      dynamodb_table = "gm-diploma-project-tf-states-lock-table"
      encrypt = true
    }
}