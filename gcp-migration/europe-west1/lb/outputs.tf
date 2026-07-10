output "gateway_ip" {
  value = module.gateway_ip.addresses[0]
}

output "hostname_suffix" {
  value = "${replace(module.gateway_ip.addresses[0], ".", "-")}.sslip.io"
}
