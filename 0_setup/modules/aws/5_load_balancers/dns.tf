
resource "aws_route53_record" "waypoint" {
  zone_id = var.zone_id
  name    = "waypoint.${var.namespace}"
  type    = "CNAME"
  records = [aws_alb.waypoint-ui.dns_name]
  ttl     = "300"
}

resource "aws_route53_record" "traefik" {
  zone_id = var.zone_id
  name    = "traefik.${var.namespace}"
  type    = "CNAME"
  records = [aws_alb.traefik.dns_name]
  ttl     = "300"

}
resource "aws_route53_record" "fabio" {
  zone_id = var.zone_id
  name    = "fabio.${var.namespace}"
  #name    = "fabio"
  type    = "CNAME"
  records = [aws_alb.fabio.dns_name]
  ttl     = "300"

}

resource "aws_route53_record" "nomad" {
  zone_id = var.zone_id
  name    = "nomad.${var.namespace}"
  // name    = "nomad"
  type    = "CNAME"
  records = [aws_alb.nomad.dns_name]
  ttl     = "300"


}



resource "aws_route53_record" "workers" {
  for_each        = toset(data.aws_instances.workers.public_ips)
  zone_id = var.zone_id
  name    = "workers-${each.key}.${var.namespace}"
  type    = "CNAME"
  records = [each.value]
  ttl     = "300"


}

