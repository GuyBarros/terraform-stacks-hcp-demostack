output "consul_public_endpoint" {
  description = "HCP Consul public endpoint URL (used to configure the consul provider)."
  value       = hcp_consul_cluster.demostack.consul_public_endpoint_url
}

output "consul_datacenter" {
  description = "HCP Consul datacenter name."
  value       = hcp_consul_cluster.demostack.datacenter
}

output "consul_root_token" {
  description = "HCP Consul root token secret ID."
  value       = hcp_consul_cluster_root_token.root.secret_id
  sensitive   = true
}

output "consul_config_file" {
  description = "Base64-encoded HCP Consul client config file."
  value       = hcp_consul_cluster.demostack.consul_config_file
  sensitive   = true
}

output "consul_ca_file" {
  description = "Base64-encoded HCP Consul CA certificate."
  value       = hcp_consul_cluster.demostack.consul_ca_file
  sensitive   = true
}

output "consul_cluster_id" {
  description = "HCP Consul cluster ID."
  value       = hcp_consul_cluster.demostack.cluster_id
}

output "vault_private_endpoint" {
  description = "HCP Vault private endpoint URL."
  value       = hcp_vault_cluster.demostack.vault_private_endpoint_url
}

output "vault_public_endpoint" {
  description = "HCP Vault public endpoint URL."
  value       = hcp_vault_cluster.demostack.vault_public_endpoint_url
}

output "vault_admin_token" {
  description = "HCP Vault admin token."
  value       = hcp_vault_cluster_admin_token.root.token
  sensitive   = true
}

output "boundary_cluster_url" {
  description = "HCP Boundary cluster URL."
  value       = hcp_boundary_cluster.demostack.cluster_url
}
