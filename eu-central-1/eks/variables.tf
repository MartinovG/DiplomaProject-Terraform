variable "aws_region" {
  default = "eu-central-1"
}

variable "vpc_name" {
  default = "gm-diploma-project-vpc"
}

variable "domain_names_public" {
  default = ["elsys.itgix.eu"]
}

variable "domain_names_private" {
  default = []
}

variable "eks_private_subnet_names" {
 default = "gm-dp-vpc-private-euce1"
}


variable "eks_public_access_cidrs" {
  description = "CIDR blocks allowed to reach the EKS public API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

