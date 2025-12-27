output "repository_names" {
  description = "The names of the repositories"
  value       = { for name, repo in module.ecr_repos : name => repo.repository_name }
}

output "repository_urls" {
  description = "Map of repository names to their URLs"
  value       = { for name, repo in module.ecr_repos : name => repo.repository_url }
}

output "repository_arns" {
  description = "Map of repository names to their ARNs"
  value       = { for name, repo in module.ecr_repos : name => repo.repository_arn }
}

output "oidc_role_arn" {
  description = "The ARN of the IAM Role for GitHub Actions"
  value       = module.github-oidc.iam_role_arn
}