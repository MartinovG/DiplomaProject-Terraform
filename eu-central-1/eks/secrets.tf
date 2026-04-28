resource "aws_secretsmanager_secret" "grafana_admin" {
    name                    = "gm-diploma-project/grafana-admin"
    recovery_window_in_days = 0

    tags = local.tags
}

resource "aws_secretsmanager_secret" "alertmanager_config" {
    name                    = "gm-diploma-project/alertmanager-config"
    recovery_window_in_days = 0

    tags = local.tags
}

resource "aws_secretsmanager_secret" "preview_db" {
    name                    = "gm-diploma-project/preview-db"
    recovery_window_in_days = 0

    tags = local.tags
}
