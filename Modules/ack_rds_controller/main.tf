resource "helm_release" "ack_rds_controller" {
  name             = var.helm_release_name
  repository       = var.helm_repo_url
  chart            = var.helm_chart_name
  version          = var.helm_chart_version
  namespace        = var.k8s_namespace
  create_namespace = false
  cleanup_on_fail  = true

  set {
    name  = "aws.region"
    value = var.aws_region
  }

  set {
    name  = "serviceAccount.name"
    value = var.k8s_service_account_name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.ack_rds_controller.arn
  }
}