output "acm_argo_arn" {
  value = module.acm_argo.acm_certificate_arn
}

output "acm_grafana_arn" {
  value = module.acm_grafana.acm_certificate_arn
}