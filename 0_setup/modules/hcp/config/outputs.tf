output "consul_acl_tokens" {
  description = "Per-worker Consul ACL token secret IDs (ordered to match worker index)."
  value       = data.consul_acl_token_secret_id.agent[*].secret_id
  sensitive   = true
}
