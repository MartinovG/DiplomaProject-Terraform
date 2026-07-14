output "secrets_to_fill" {
    value = [for s in google_secret_manager_secret.gm_secrets : s.secret_id]
}