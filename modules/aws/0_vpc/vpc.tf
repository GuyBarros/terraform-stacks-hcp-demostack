terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55"
    }
  }
}
resource "aws_vpc" "demostack" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = var.namespace
  }
}

resource "aws_key_pair" "demostack" {
  key_name   = var.namespace
  public_key = var.public_key
}

resource "aws_kms_key" "demostackVaultKeys" {
  description             = "KMS for the Vault Demo"
  deletion_window_in_days = 10

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role" "consul-join" {
  name = "${var.namespace}-consul-join"

  # jsonencode produces stable JSON with no whitespace drift between plans
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
        Sid       = ""
      }
    ]
  })
}

resource "aws_iam_policy" "consul-join" {
  name        = "${var.namespace}-consul-join"
  description = "Allows nodes to describe instances and use KMS."
  policy      = data.aws_iam_policy_document.vault-server.json
}

# aws_iam_role_policy_attachment is idempotent and converges cleanly.
# aws_iam_policy_attachment is NOT — it resets all other attachments on every
# apply, causing perpetual diffs when other things attach to the same policy.
resource "aws_iam_role_policy_attachment" "consul-join" {
  role       = aws_iam_role.consul-join.name
  policy_arn = aws_iam_policy.consul-join.arn
}

resource "aws_iam_instance_profile" "consul-join" {
  name = "${var.namespace}-consul-join"
  role = aws_iam_role.consul-join.name
}

data "aws_iam_policy_document" "vault-server" {
  statement {
    sid    = "VaultKMSUnseal"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
    resources = [aws_kms_key.demostackVaultKeys.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "iam:PassRole",
      "iam:ListRoles",
      "cloudwatch:PutMetricData",
      "ec2messages:*",
      "logs:*",
    ]
    resources = ["*"]
  }
}

variable "region" {
  description = "The region to create resources."
  default     = "eu-west-2"
}
