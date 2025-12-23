resource "aws_iam_policy" "external_secrets" {
  name = "${local.name}-external-secrets-policy"
  description = "Allow ESO to read Secret Managaer secrets for gmDiplomaProject"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:prod/gm-diploma/*"
      }
    ]
  })
}