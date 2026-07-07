provider "google" {
  project = var.project_id
  region  = var.region
}

module "artifact_registry" {
  source  = "GoogleCloudPlatform/artifact-registry/google"
  version = "~> 0.8"

  project_id = var.project_id
  location   = var.region
  format     = var.format

  for_each = var.repository_ids
  repository_id = each.value

  docker_config = {
    immutable_tags = true
  }

  cleanup_policies = {
  "expire-after-14-days" = {
    action = "DELETE"
    condition = {
      tag_state = "TAGGED"
      tagPrefixes = ["backend-pr-", "frontend-pr-"]
      olderThan = "14d"
    }
  }

  "keep-last-30-prod" = {
    action = "DELETE"
    condition = {
      tag_state = "TAGGED"
      tagPrefixes = ["backend-sha-", "frontend-sha-"]
      maxNumNewerVersions = 30
    }
  }

  "expire-untagged-after-1-day" = {
    action = "DELETE"
    condition = {
      tag_state = "UNTAGGED"
      olderThan = "1d"
    }
  }
}
}

