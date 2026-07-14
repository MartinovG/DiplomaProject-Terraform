provider "google" {
  project = var.project_id
  region = var.region
}

locals {
    secrets = [
        "gm-prod-db-password",
        "gm-preview-db-password",
        "grafana-admin-password",
        "github-token"
    ]
}

module "eso_wi" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "~> 44.0"

  project_id = var.project_id
  name = "external-secrets"
  namespace = "eso"
  use_existing_k8s_sa = true
  annotate_k8s_sa = false

}

resource "google_secret_manager_secret" "gm_secrets" {
  for_each = toset(local.secrets)
  secret_id = each.value

  replication {
    user_managed {
      replicas {
        location = "europe-west1"
      }
    }
  }
}

resource "google_secret_manager_secret_iam_member" "secret_access" {
  for_each = google_secret_manager_secret.gm_secrets

  secret_id = each.value.id
  role = "roles/secretmanager.secretAccessor"
  member = module.eso_wi.gcp_service_account_fqn
}
