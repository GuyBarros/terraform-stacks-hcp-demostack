# output "aws_instance_workers_ids" {
#   description = "The list of compute ids"
#   type        = list(string)
#   value       = component.compute.aws_instance_workers_ids
# }

# output "aws_instance_workers_public_dns" {
#   description = "The list of compute public dns"
#   type        = list(string)
#   value       = component.compute.aws_instance_workers_public_dns
# }


# output "workers" {
#   value       = component.load_balancer.workers
#   description = "FQDN of the workers"
#   type        = object
# }

output "traefik_lb" {
  value       = component.load_balancer.traefik_lb
  description = "FQDN for the Traefik Load Balancer"
  type        = string
}

output "fabio_lb" {
  value       = component.load_balancer.fabio_lb
  description = "FQDN for the Fabio Load Balancer"
  type        = string
}

output "nomad_ui" {
  value       = component.load_balancer.nomad_ui
  description = "FQDN for the Nomad Load Balancer"
  type        = string
}

output "waypoint_ui" {
  value       = component.load_balancer.waypoint_ui
  description = "FQDN for the Waypoint UI Load Balancer"
  type        = string
}

output "waypoint" {
  value       = component.load_balancer.waypoint
  description = "FQDN for the Waypoint UI Load Balancer"
  type        = string
}
