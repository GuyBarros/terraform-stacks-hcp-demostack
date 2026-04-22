# components/hashistack-cluster/outputs.tf
# These outputs are consumed by demostack.tfstack.hcl to surface
# per-cluster endpoints at the stack level.

output "consul_ui" {
  description = "Consul UI URL."
  value       = module.cluster.consul_ui
}

output "vault_ui" {
  description = "Vault UI URL."
  value       = module.cluster.vault_ui
}

output "nomad_ui" {
  description = "Nomad UI URL."
  value       = module.cluster.nomad_ui
}

output "fabio_lb" {
  description = "Fabio load-balancer endpoint."
  value       = module.cluster.fabio_lb
}

output "traefik_lb" {
  description = "Traefik load-balancer endpoint."
  value       = module.cluster.traefik_lb
}

output "boundary_ui" {
  description = "Boundary UI URL."
  value       = module.cluster.boundary_ui
}

output "servers" {
  description = "Server node details."
  value       = module.cluster.servers
}

output "consul_gossip_key" {
  description = "Base64-encoded Consul gossip encryption key (sensitive)."
  value       = random_id.consul_gossip_key.b64_std
  sensitive   = true
}

output "nomad_gossip_key" {
  description = "Base64-encoded Nomad gossip encryption key (sensitive)."
  value       = random_id.nomad_gossip_key.b64_std
  sensitive   = true
}
