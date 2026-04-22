# outputs.tfcomponent.hcl
# Mirrors the outputs from the original terraform-hcp-demostack-aws repo,
# adapted for the Stacks component structure. consul_address and consul_token
# are omitted as HCP Consul has been removed from this stack.

# ---------------------------------------------------------------------------
# Load balancer endpoints
# ---------------------------------------------------------------------------

output "workers" {
  description = "FQDN of each worker node (Route 53 records)."
  type        = map(string)
  value       = { for k, v in component.load_balancer.workers : k => v.fqdn }
}

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

# ---------------------------------------------------------------------------
# HCP endpoints
# ---------------------------------------------------------------------------

output "boundary_address" {
  description = "HCP Boundary cluster URL."
  type        = string
  value       = component.hcp_clusters.boundary_cluster_url
}

output "vault_address" {
  description = "HCP Vault public endpoint URL."
  type        = string
  value       = component.hcp_clusters.vault_public_endpoint
}

output "vault_token" {
  description = "HCP Vault admin token."
  type        = string
  sensitive   = false
  value       = nonsensitive(component.hcp_clusters.vault_admin_token)
}

# ---------------------------------------------------------------------------
# Combined config block — drop-in for the boundary demo setup
# ---------------------------------------------------------------------------

output "XX_boundary_config" {
  description = "Ready-to-use config block for the Boundary demo setup."
  type        = string
  sensitive   = false
  value       = <<-EOF
    application_name          = "${var.namespace}"
    boundary_address          = "${component.hcp_clusters.boundary_cluster_url}"
    boundary_auth_method_id   = ""
    boundary_username         = "admin"
    boundary_password         = "Welcome1!"
    vault_address             = "${component.hcp_clusters.vault_public_endpoint}"
    vault_token               = "${nonsensitive(component.hcp_clusters.vault_admin_token)}"
    vault_namespace           = "boundary"
    nomad_address             = "${component.load_balancer.nomad_ui}"
    nomad_token               = ""
  EOF
}
