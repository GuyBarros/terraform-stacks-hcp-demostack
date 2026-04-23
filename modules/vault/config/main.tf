terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}

resource "vault_mount" "nomad_config" {
  path        = "nomad-config"
  type        = "kv"
  options     = { version = "2" }
  description = "KV store for Nomad runtime configuration."
}

resource "vault_kv_secret_v2" "nomad_license" {
  mount               = vault_mount.nomad_config.path
  name                = "license"
  delete_all_versions = true

  data_json = jsonencode({
    value = var.nomadlicense
  })
}
