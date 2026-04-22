# modules/aws/5_load_balancers/tls.tf
# ACM wildcard certificate for the ALB HTTPS listeners.
# The root CA cert is generated in the compute module and passed in via
# var.tls_ca_cert_pem — this avoids a circular dependency between components.

data "aws_route53_zone" "fdqn" {
  zone_id = var.zone_id
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.namespace}.${data.aws_route53_zone.fdqn.name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_record : record.fqdn]
}
