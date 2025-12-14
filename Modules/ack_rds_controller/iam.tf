# 1. Create Namespace (if not kube-system)
resource "kubernetes_namespace" "ack_system" {
  count = var.k8s_namespace != "kube-system" ? 1 : 0
  metadata {
    name = var.k8s_namespace
  }
}

data "aws_iam_policy_document" "ack_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account_name}"]
    }
  }
}

resource "aws_iam_role" "ack_rds_controller" {
  name               = "${var.cluster_name}-ack-rds-controller"
  assume_role_policy = data.aws_iam_policy_document.ack_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ack_rds_full_access" {
  role       = aws_iam_role.ack_rds_controller.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}