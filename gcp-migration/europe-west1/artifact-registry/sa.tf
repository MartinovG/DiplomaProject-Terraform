module "github_ci_sa" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.7"

  project_id = var.project_id
  names      = ["github-actions-ci"]
  display_name = "GitHub Actions CI - Wif"
}
