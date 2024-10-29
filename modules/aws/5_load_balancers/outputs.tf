output "workers" {
  value = aws_route53_record.workers
}


output "traefik_lb" {
  value = "http://${aws_route53_record.traefik.fqdn}:8080"
}

output "fabio_lb" {
  value = "http://${aws_route53_record.fabio.fqdn}:9999"
}


output "nomad_ui" {
  value = "https://${aws_route53_record.nomad.fqdn}:4646"
}


output "waypoint_ui" {
  value = "https://${aws_route53_record.waypoint.fqdn}:9702"
}

output "waypoint" {
  value = "${aws_route53_record.waypoint.fqdn}:9701"
}