output "workload_identity_provider" {
  value = module.github_wif.provider_name
}

output "ci_service_account_email" {
  value = module.github_ci_sa.email
}

output "registry_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/gm-diploma-project"
}