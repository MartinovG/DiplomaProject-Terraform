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
    name = "external-dns"
    repository = "https://kubernetes-sigs.github.io/external-dns/"
    chart = "external-dns"
    namespace  = "kube-system"
    version    = var.helm_chart_version
    cleanup_on_fail = true
    max_history = 10

    set = local.external_dns_set
  
}