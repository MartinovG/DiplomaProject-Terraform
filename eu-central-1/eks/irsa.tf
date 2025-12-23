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

module "karpenter_irsa" {
    source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
    version = "6.2.3"

    name = "${local.name}-karpenter"
    policies = {
        karpenter = module.karpenter.karpenter.iam_policy_arn
    }

    oidc_providers = {
        main = {
            provider_arn = module.eks.oidc_provider_arn
            namespace_service_accounts = ["karpenter:karpenter"]
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

module "external_secrets_irsa" {
    source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
    version = "6.2.3"

    name = "${local.name}-external-secrets-irsa"
    policies = {
        policy = aws_iam_policy.external_secrets.arn
    }

    oidc_providers = {
        main = {
            provider_arn = module.eks.oidc_provider_arn
            namespace_service_accounts = ["external-secrets:external-secrets"]
        }
    }

    tags = local.tags
}