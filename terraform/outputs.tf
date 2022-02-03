output "instance_ip_addr" {
  value = var.host_enable ? aws_instance.docker_host[0].public_ip : null
}

output "instance_dns_addr" {
  value = var.host_enable ? aws_route53_record.docker_host[0].fqdn : null
}
