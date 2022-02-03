resource "aws_route53_record" "docker_host" {
  # Enable or disable the instance with a variable
  count = var.host_enable ? 1 : 0

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = data.aws_ssm_parameter.host_route53_address_prefix.value
  type    = "A"
  ttl     = "300"
  records = [aws_instance.docker_host[0].public_ip]
}
