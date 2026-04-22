# modules/hcp/config/main.tf
# Configures ACL policies and tokens in the HCP Consul cluster, and registers
# HCP Vault and Boundary as Consul services.
# Requires the consul provider to be pre-configured with the cluster endpoint
# and root token — done at the stack level using hcp_clusters outputs.

# ---------------------------------------------------------------------------
# ACL policies
# ---------------------------------------------------------------------------

resource "consul_acl_policy" "agent" {
  name        = "agent"
  datacenters = [var.consul_datacenter]
  rules       = <<-RULE
    agent_prefix "" {
      policy = "write"
    }
    node_prefix "" {
      policy = "write"
    }
    service "nomad" {
      policy = "write"
    }
    service_prefix "" {
      policy = "write"
    }
    namespace_prefix "" {
      acl = "write"
      service_prefix "" {
        policy = "write"
      }
    }
    acl      = "write"
    operator = "write"
  RULE
}

resource "consul_acl_policy" "anon" {
  name        = "anon"
  datacenters = [var.consul_datacenter]
  rules       = <<-RULE
    node_prefix "" {
      policy = "read"
    }
    service_prefix "" {
      policy = "read"
    }
    key_prefix "" {
      policy = "read"
    }
    agent_prefix "" {
      policy = "write"
    }
  RULE
}

resource "consul_acl_token_policy_attachment" "anon_readonly" {
  token_id = "00000000-0000-0000-0000-000000000002"
  policy   = consul_acl_policy.anon.name
}

# ---------------------------------------------------------------------------
# Per-worker ACL tokens
# ---------------------------------------------------------------------------

resource "consul_acl_token" "agent" {
  count       = var.workers
  description = "Worker ${count.index} agent token"
  policies    = [consul_acl_policy.agent.name]
  local       = true
}

data "consul_acl_token_secret_id" "agent" {
  count       = var.workers
  accessor_id = consul_acl_token.agent[count.index].id
}

# ---------------------------------------------------------------------------
# Register HCP Vault as a Consul service
# ---------------------------------------------------------------------------

resource "consul_node" "vault" {
  name    = "compute-vault"
  address = replace(var.vault_private_endpoint, ":8200", "")
}

resource "consul_service" "vault" {
  name = "vault"
  node = consul_node.vault.name
  port = 8200
  tags = ["hcp", "vault"]

  check {
    check_id                          = "vault_health_check"
    name                              = "hcp vault health check"
    status                            = "passing"
    http                              = "${var.vault_private_endpoint}/v1/sys/health"
    method                            = "GET"
    interval                          = "15s"
    timeout                           = "10s"
    deregister_critical_service_after = "30s"
  }
}

# ---------------------------------------------------------------------------
# Register HCP Boundary as a Consul service
# ---------------------------------------------------------------------------

resource "consul_node" "boundary" {
  name    = "compute-boundary"
  address = var.boundary_cluster_url
}

resource "consul_service" "boundary" {
  name = "boundary"
  node = consul_node.boundary.name
  port = 443
  tags = ["hcp", "boundary"]

  check {
    check_id                          = "boundary_health_check"
    name                              = "hcp boundary health check"
    status                            = "passing"
    http                              = var.boundary_cluster_url
    method                            = "GET"
    interval                          = "15s"
    timeout                           = "10s"
    deregister_critical_service_after = "30s"
  }
}
