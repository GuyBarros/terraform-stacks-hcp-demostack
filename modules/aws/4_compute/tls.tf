# modules/aws/4_compute/tls.tf
# TLS root CA and per-worker certificates.
# These are generated here (in compute) because they are consumed by the
# worker cloud-init scripts. The root CA cert is also exposed as an output
# so the load_balancer component can use it for ACM validation.

# Root private key
resource "tls_private_key" "root" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

# Root self-signed CA certificate
resource "tls_self_signed_cert" "root" {
  private_key_pem = tls_private_key.root.private_key_pem

  subject {
    common_name  = var.namespace
    organization = "HashiCorp Demostack"
  }

  validity_period_hours = "720" # 30 days

  allowed_uses = [
    "cert_signing",
    "digital_signature",
    "crl_signing",
  ]

  is_ca_certificate = true
}

# Per-worker private keys
resource "tls_private_key" "workers" {
  count       = var.workers
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

# Per-worker CSRs
resource "tls_cert_request" "workers" {
  count           = var.workers
  private_key_pem = element(tls_private_key.workers[*].private_key_pem, count.index)

  subject {
    common_name  = "${var.namespace}-worker-${count.index}.node.consul"
    organization = "HashiCorp Demostack"
  }

  dns_names = [
    "${var.namespace}-worker-${count.index}.node.consul",
    "${var.namespace}-worker-${count.index}.node.${var.region}.consul",
    "nomad.service.consul",
    "nomad.service.${var.region}.consul",
    "client.global.nomad",
    "server.global.nomad",
    "localhost",
    "127.0.0.1",
  ]
}

# Per-worker signed certificates
resource "tls_locally_signed_cert" "workers" {
  count            = var.workers
  cert_request_pem = element(tls_cert_request.workers[*].cert_request_pem, count.index)

  ca_private_key_pem = tls_private_key.root.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.root.cert_pem

  validity_period_hours = "720" # 30 days

  allowed_uses = [
    "client_auth",
    "digital_signature",
    "key_agreement",
    "key_encipherment",
    "server_auth",
  ]
}
