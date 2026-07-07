module "github_service_account" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.7"

  project_id = var.project_id
  names      = ["github-actions-sa"]
}

module "github_oidc" {
  source  = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version = "~> 5.1"

  project_id = var.project_id
  pool_id = "github-actions-pool"
  provider_id = "github-oidc-provider"

  sa_mapping = {
    "github-actions-sa" = {
        sa_name = "projects/${var.project_id}/serviceAccounts/${module.github_service_account.emails["github-actions-sa"]}"
        attribute = "attribute.repository_owner/MartinovG"
    }
  }
}