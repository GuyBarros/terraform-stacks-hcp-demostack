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

output "tls_ca_cert_pem" {
  description = "Root CA certificate PEM — passed to load_balancer for ACM wildcard cert."
  value       = tls_self_signed_cert.root.cert_pem
}
