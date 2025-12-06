resource "helm_release" "alb_ingress" {
    depends_on = [var.mod_dependency]
    count = var.enabled? 1 : 0
    name = var.helm_release_name
    repository = var.helm_repo_url
    chart = var.helm_chart_name
    namespace  = var.k8s_namespace
    version = var.helm_chart_version
    cleanup_on_fail = true
    max_history = 10

    dynamic "set" {
        for_each = [
            {
                name  = "clusterName"
                value = var.cluster_name
            },
            {
                name  = "rbac.create"
                value = "true"
            },
            {
                name  = "rbac.serviceAccount.create"
                value = "true"
            },
            {
                name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
                value = aws_iam_role.alb_ingress[0].arn
            }
        ]
        content {
            name  = set.value.name
            value = set.value.value
        }
    }

    dynamic "set" {
        for_each = var.settings
        content {
            name  = set.key
            value = set.value
        }
    }

}