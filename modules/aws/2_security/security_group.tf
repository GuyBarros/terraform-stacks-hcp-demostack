data "aws_vpc" "demostack" {
  id = var.vpc_id
}

resource "aws_security_group" "demostack" {
  name_prefix = var.namespace
  vpc_id      = data.aws_vpc.demostack.id

  # Allow all internal traffic within the VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.demostack.cidr_block]
  }

  # SSH
  dynamic "ingress" {
    for_each = var.host_access_ip
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # RDP
  dynamic "ingress" {
    for_each = var.host_access_ip
    content {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # LDAP TCP + UDP
  dynamic "ingress" {
    for_each = var.host_access_ip
    content {
      from_port   = 389
      to_port     = 389
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  dynamic "ingress" {
    for_each = var.host_access_ip
    content {
      from_port   = 389
      to_port     = 389
      protocol    = "udp"
      cidr_blocks = [ingress.value]
    }
  }

  # LDAPS TCP + UDP
  dynamic "ingress" {
    for_each = var.host_access_ip
    content {
      from_port   = 636
      to_port     = 636
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  dynamic "ingress" {
    for_each = var.host_access_ip
    content {
      from_port   = 636
      to_port     = 636
      protocol    = "udp"
      cidr_blocks = [ingress.value]
    }
  }

  # HTTP / HTTPS
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # Vault, Consul, Boundary (8000-9300)
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 8000
      to_port     = 9300
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # Fabio (9998-9999)
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 9998
      to_port     = 9999
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # Nomad (3000-4999, 20000-29999, 30000-39999)
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 3000
      to_port     = 4999
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 20000
      to_port     = 29999
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 30000
      to_port     = 39999
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # Waypoint (9700-9702)
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 9700
      to_port     = 9702
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # Postgres + pgAdmin (5000-5500)
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 5000
      to_port     = 5500
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # MySQL (3306)
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # PostgreSQL (5432)
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # Oracle (1521)
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 1521
      to_port     = 1521
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
