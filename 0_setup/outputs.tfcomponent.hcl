# outputs.tfcomponent.hcl
# Stack-level outputs surfaced after a successful apply.

output "traefik_lb" {
  description = "Traefik load balancer URL."
  type        = string
  value       = component.load_balancer.traefik_lb
}

output "fabio_lb" {
  description = "Fabio load balancer URL."
  type        = string
  value       = component.load_balancer.fabio_lb
}

output "nomad_ui" {
  description = "Nomad UI URL."
  type        = string
  value       = component.load_balancer.nomad_ui
}

output "waypoint_ui" {
  description = "Waypoint UI URL."
  type        = string
  value       = component.load_balancer.waypoint_ui
}

output "waypoint" {
  description = "Waypoint gRPC endpoint."
  type        = string
  value       = component.load_balancer.waypoint
}
