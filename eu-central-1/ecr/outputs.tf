output "repository_name" {
  description = "The name of the repository"
  value       = module.ecr_api.repository_name
}

output "repository_url" {
  description = "The URL of the repository (for docker push)"
  value       = module.ecr_api.repository_url
}

output "repository_arn" {
  description = "The ARN of the repository"
  value       = module.ecr_api.repository_arn
}

output "oidc_role_arn" {
  description = "The ARN of the IAM Role for GitHub Actions"
  value       = module.github-oidc.iam_role_arn
}