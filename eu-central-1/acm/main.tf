locals {
    argocd_hostname = "argocd-gmdiplomaproject.elsys.itgix.eu" 
    grafana_hostname = "grafana-gmdiplomaproject.elsys.itgix.eu"
    tags = {
      Project = "gm-diploma-project"
      Terraform = "true"
    }
}


module "acm_argo" {
  source  = "terraform-aws-modules/acm/aws"
  version = "6.2.0"

  domain_name       = local.argocd_hostname
  validation_method = "DNS"

  zone_id = data.aws_route53_zone.elsys.zone_id

  tags = local.tags
}

module "acm_grafana" {
  source  = "terraform-aws-modules/acm/aws"
  version = "6.2.0"

  domain_name       = local.grafana_hostname
  validation_method = "DNS"

  zone_id = data.aws_route53_zone.elsys.zone_id

  tags = local.tags
}