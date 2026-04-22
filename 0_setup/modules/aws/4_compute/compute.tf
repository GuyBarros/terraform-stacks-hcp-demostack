data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# Gossip key uses a keeper so it only regenerates when the namespace changes,
# not on every plan. This prevents user_data churn → instance replacement loops.
resource "random_id" "nomad_gossip_key" {
  byte_length = 16

  keepers = {
    namespace = var.namespace
  }
}

data "cloudinit_config" "workers" {
  count = var.workers

  gzip          = true
  base64_encode = true

  # Step 1 — Docker
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/templates/shared/docker.sh")
  }

  # Step 2 — Hashicorp binaries
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/shared/hashicorp.sh", {
      enterprise = var.enterprise
    })
  }

  # Step 3 — Vault policies and token roles
  # vault_token is only used here at first boot to set up policies.
  # Subsequent token rotations do NOT trigger instance replacement because
  # user_data_replace_on_change is false — see aws_instance below.
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/workers/vault.sh", {
      VAULT_ADDR  = var.vault_addr
      VAULT_TOKEN = var.vault_token
    })
  }

  # Step 4 — Nomad (client + server)
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/workers/nomad.sh", {
      node_name        = "${var.namespace}-worker-${count.index}"
      hcp_acl_token    = ""
      VAULT_ADDR       = var.vault_addr
      VAULT_TOKEN      = var.vault_token
      nomad_workers    = var.workers
      nomad_gossip_key = random_id.nomad_gossip_key.b64_std
      cni_plugin_url   = var.cni_plugin_url
      run_nomad_jobs   = var.run_nomad_jobs
      nomadlicense     = var.nomadlicense
      region           = var.region
      index                        = count.index + 1
      count                        = var.workers
      aws_ebs_volume_prometheus_id = aws_ebs_volume.prometheus.id
      aws_ebs_volume_shared_id     = aws_ebs_volume.shared.id
    })
  }
}

resource "aws_instance" "workers" {
  count = var.workers

  ami           = data.aws_ami.ubuntu.image_id
  instance_type = var.instance_type_worker
  key_name      = var.aws_key_pair_id

  monitoring = true

  subnet_id              = element(var.subnet_ids[*], count.index)
  iam_instance_profile   = var.aws_iam_instance_profile_name
  vpc_security_group_ids = var.vpc_security_group_ids

  root_block_device {
    volume_size           = "240"
    delete_on_termination = "true"
  }

  ebs_block_device {
    device_name           = "/dev/xvdd"
    volume_type           = "gp2"
    volume_size           = "240"
    delete_on_termination = "true"
  }

  tags = {
    Purpose  = var.namespace
    Function = "worker"
    Name     = "demostack-worker-${count.index}"
  }

  # Do NOT replace instances when user_data changes after initial creation.
  # The vault_token and gossip key are bootstrap values — rotating them in
  # HCP does not require rebuilding the fleet. Set to true only deliberately
  # (e.g. during a full cluster repave).
  user_data_replace_on_change = false
  user_data_base64            = element(data.cloudinit_config.workers[*].rendered, count.index)

  lifecycle {
    # Prevent AMI updates from silently replacing running workers.
    # Update ami deliberately when you want to repave.
    ignore_changes = [ami, user_data_base64]
  }
}
