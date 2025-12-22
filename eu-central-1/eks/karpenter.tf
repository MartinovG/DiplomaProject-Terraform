module "karpenter" {
    source = "aws-ia/eks-blueprints-addons/aws"
    version = "~> 1.23.0"

    cluster_name = module.eks.cluster_name
    cluster_endpoint = module.eks.cluster_endpoint
    cluster_version = module.eks.cluster_version
    oidc_provider_arn = module.eks.oidc_provider_arn

    create_delay_dependencies = [for i in module.eks.eks_managed_node_groups : i.node_group_arn]

    enable_metrics_server = true
    enable_karpenter = true
    
    karpenter = {
        repository_username = data.aws_ecrpublic_authorization_token.token.user_name
        repository_password = data.aws_ecrpublic_authorization_token.token.password
        create_role = true
        create_policy = true
        chart_version = "1.6.3"

        set = [
            {
                name  = "clusterName"
                value = module.eks.cluster_name
            },
            {
                name  = "clusterEndpoint"
                value = module.eks.cluster_endpoint
            },
            {
                name  = "settings.featureGates.spotToSpotConsolidation"
                value = true
            }
        ]

        oidc_providers = {
            this = {
                provider_arn = module.eks.oidc_provider_arn
                service_account = "karpenter"
            }
        }
    }

    karpenter_enable_spot_termination = true
    karpenter_enable_instance_profile_creation = true
    karpenter_node = {
        iam_role_use_name_prefix = false
    }

    tags = local.tags
}

data "aws_ecrpublic_authorization_token" "token" {
    provider = aws.virginia
}

provider "aws" {
    alias  = "virginia"
    region = "us-east-1"
}