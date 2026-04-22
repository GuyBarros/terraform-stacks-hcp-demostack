output "worker_ids" {
  description = "EC2 instance IDs of the worker nodes."
  value       = aws_instance.workers[*].id
}

output "worker_public_ips" {
  description = "Public IP addresses of the worker nodes."
  value       = aws_instance.workers[*].public_ip
}

output "nomad_gossip_key" {
  description = "Base64-encoded Nomad gossip encryption key."
  value       = random_id.nomad_gossip_key.b64_std
  sensitive   = true
}
