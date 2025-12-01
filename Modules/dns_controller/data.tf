data "aws_route53_zone" "external_dns_public" {
  for_each = toset(var.domain_names_public)
  name     = each.value
}

data "aws_route53_zone" "external_dns_private" {
  for_each = toset(var.domain_names_private)
  name     = each.value
  private_zone = true
}