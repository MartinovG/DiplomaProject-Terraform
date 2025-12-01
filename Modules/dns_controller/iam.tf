data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      identifiers = [var.cluster_identity_oidc_issuer_arn]
      type        = "Federated"
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.k8s_namespace}:${local.external_dns_service_account_name}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "external_dns" {
  name        = "eks-external-dns-${var.k8s_cluster_name}"
  description = "Permissions required by the Kubernetes AWS EKS External Name controller to do it's job."
  path        = "/"

  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json

}
data "aws_iam_policy_document" "external_dns" {
  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = values(data.aws_route53_zone.external_dns_public)[*].arn
  }
  dynamic "statement" {
    for_each = length(values(data.aws_route53_zone.external_dns_private)) > 0 ? [1] : []
    content {
      actions = [
        "route53:ChangeResourceRecordSets",
      ]

      resources = values(data.aws_route53_zone.external_dns_private)[*].arn
    }
  }
  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "external_dns" {
  name        = "external-dns-${var.k8s_cluster_name}"
  description = "Allows access to resources needed to run external dns."
  policy      = data.aws_iam_policy_document.external_dns.json
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.external_dns.arn
}