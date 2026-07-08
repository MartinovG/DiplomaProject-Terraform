module "github_wif" {
  source  = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version = "~> 5.1"

  project_id = var.project_id
  pool_id = "github-actions-pool"
  provider_id = "github-actions-provider"

  attribute_mapping = {
    "google.subject" = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  attribute_condition = "assertion.repository.owner == \"${var.github_owner}\""

  sa_mapping = {
    for repo in var.github_repositories :
    replace(repo, "/", "-") => {
      sa_name = "projects/${var.project_id}/serviceAccounts/${module.github_ci_sa.email}"
      attribute = "attribute.repository/${repo}"
    }
  }
}