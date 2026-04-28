module "vpc_cni_irsa" {
    source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
    version = "6.2.3"

    name = "${local.name}-vpc-cni"
    attach_vpc_cni_policy = true
    vpc_cni_enable_ipv4 = true

    oidc_providers = {
        main = {
            provider_arn = module.eks.oidc_provider_arn
            namespace_service_accounts = ["kube-system:aws-node"]
        }
    }

    tags = local.tags
}


module "ebs_csi_irsa" {
    source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
    version = "6.2.3"

    name = "${local.name}-ebs-csi"
    attach_ebs_csi_policy = true

    oidc_providers = {
        main = {
            provider_arn = module.eks.oidc_provider_arn
            namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
        }
    }

    tags = local.tags
}

resource "aws_iam_policy" "external_secrets" {
    name        = "gm-diploma-external-secrets-policy"
    description = "Allow External Secrets Operator to read secrets from Secrets Manager"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "secretsmanager:GetSecretValue",
                    "secretsmanager:DescribeSecret"
                ]
                Resource = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:gm-diploma-project/*"
            }
        ]
    })

    tags = local.tags
}

module "external_secrets_irsa" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
    version = "6.2.3"

    name            = "gm-diploma-external-secrets-role"
    use_name_prefix = false
    policies = {
        external_secrets = aws_iam_policy.external_secrets.arn
    }

    oidc_providers = {
        main = {
            provider_arn               = module.eks.oidc_provider_arn
            namespace_service_accounts = ["external-secrets:external-secrets"]

        }
    }

    tags = local.tags
}