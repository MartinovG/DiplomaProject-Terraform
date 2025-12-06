locals {
    external_dns_service_account_name = "external-dns"

    external_dns_set = concat (
        [
            {
                name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
                value = aws_iam_role.external_dns.arn
            }
        ],
        [
            for key, value in var.settings : {
                name  = key
                value = value
            }
        ]
    )
}

resource "helm_release" "external_dns_helm" {
    name = var.helm_release_name
    repository = var.helm_repo_url
    chart = var.helm_chart_name
    namespace  = var.k8s_namespace
    version    = var.helm_chart_version
    cleanup_on_fail = true
    max_history = 10

    set {
        name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
        value = aws_iam_role.external_dns.arn
    }

    dynamic "set" {
        for_each = var.settings

        content {
            name  = set.key
            value = set.value
        }
    }

    dynamic "set_list" {
        for_each = var.settings_list

        content {
            name  = set_list.key
            value = set_list.value
        }
    }
}