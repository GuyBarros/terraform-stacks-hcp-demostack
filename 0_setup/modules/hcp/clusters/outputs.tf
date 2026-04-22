output "vault_private_endpoint" {
  description = "HCP Vault private endpoint URL."
  value       = hcp_vault_cluster.demostack.vault_private_endpoint_url
}

output "vault_public_endpoint" {
  description = "HCP Vault public endpoint URL."
  value       = hcp_vault_cluster.demostack.vault_public_endpoint_url
}

output "vault_admin_token" {
  description = "HCP Vault admin token for bootstrap."
  value       = hcp_vault_cluster_admin_token.root.token
  sensitive   = true
}

output "boundary_cluster_url" {
  description = "HCP Boundary cluster URL."
  value       = hcp_boundary_cluster.demostack.cluster_url
}
