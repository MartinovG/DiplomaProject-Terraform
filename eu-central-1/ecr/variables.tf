variable "aws_region" {
    default     = "eu-central-1"
}

variable "repository_names" {
  description = "List of ECR repository names to create"
  type        = set(string)
  default     = [
    "gm-diploma-project-ecr-api",
    "gm-diploma-project-ecr-frontend"
  ]
}