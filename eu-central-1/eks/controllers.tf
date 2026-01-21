module "dns_controller" {
    source = "../../Modules/dns_controller"
    k8s_cluster_name = module.eks.cluster_name
    k8s_cluster_type = "eks"
    k8s_namespace = "kube-system"
    helm_chart_version = "1.19.0"
    helm_repo_url = "https://kubernetes-sigs.github.io/external-dns/" 
    helm_chart_name = "external-dns"
    helm_release_name = "external-dns"

    settings = {
        txtOwnerId = "${module.eks.cluster_name}-dns"
        policy = "sync"
    }

    settings_list = {
        domainFilters = concat(var.domain_names_public, var.domain_names_private)
    }

    domain_names_public = var.domain_names_public
    domain_names_private = var.domain_names_private
    deployment_service_account = "external-dns"
    cluster_identity_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
    cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn

    depends_on = [module.eks]
}

module "alb_controller" {
    source = "../../Modules/alb_controller"
    cluster_name = module.eks.cluster_name
    enabled = true
    k8s_namespace = "kube-system"
    k8s_service_account_name = "aws-load-balancer-controller"
    helm_chart_version = "1.13.4"
    helm_repo_url = "https://aws.github.io/eks-charts"
    helm_chart_name = "aws-load-balancer-controller"
    helm_release_name = "aws-load-balancer-controller"

    cluster_identity_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
    cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn

    settings = {
        vpcId = data.aws_vpc.current.id
        region = var.aws_region
    }

    depends_on = [module.eks]
}

module "ack_rds_controller" {
  source = "../../Modules/ack_rds_controller"
  cluster_name = module.eks.cluster_name
  aws_region = var.aws_region
  helm_chart_name = "rds-chart"
  helm_chart_version = "1.7.3"
  helm_repo_url = "oci://public.ecr.aws/aws-controllers-k8s"
  helm_release_name = "ack-rds-controller"

  cluster_identity_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn

  depends_on = [module.eks]
}