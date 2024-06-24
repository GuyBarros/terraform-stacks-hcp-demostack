
resource "aws_security_group" "demostack" {
  name_prefix = var.namespace
  vpc_id      = aws_vpc.demostack.id
  #Allow internal communication between nodes
  ingress {
    from_port = -1
    to_port   = -1
    protocol  = -1
  }


  # SSH access if host_access_ip has CIDR blocks
  dynamic "ingress" {
    for_each = var.host_access_ip
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  # RDS access if host_access_ip has CIDR blocks
  dynamic "ingress" {
    for_each = var.host_access_ip
    content {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # LDAP
  #TCP
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


  # sLDAP
   #TCP
  dynamic "ingress" {
    for_each = var.host_access_ip
    content {
      from_port   = 636
      to_port     = 636
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  #UDP
  dynamic "ingress" {
    for_each = var.host_access_ip
    content {
      from_port   = 636
      to_port     = 636
      protocol    = "udp"
      cidr_blocks = [ingress.value]
    }
  }
/*
  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block]
  }
  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "udp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block]
  }

  ingress {
    from_port   = 636
    to_port     = 636
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block]
  }
  ingress {
    from_port   = 636
    to_port     = 636
    protocol    = "udp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block]
  }

  #Demostack Postgres + pgadmin
  ingress {
    from_port   = 5000
    to_port     = 5500
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }
  #waypoint ports
  ingress {
    from_port   = 9700
    to_port     = 9702
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }


  #Consul and Vault and Boundary ports
  ingress {
    from_port   = 8000
    to_port     = 9300
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }
  #Fabio Ports
  ingress {
    from_port   = 9998
    to_port     = 9999
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }
  #Nomad
  ingress {
    from_port   = 3000
    to_port     = 4999
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }
  #More nomad ports
  ingress {
    from_port   = 20000
    to_port     = 29999
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 39999
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }


  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }


  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "udp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }


  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }

  
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "udp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }

  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "udp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }

  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "udp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }

  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "udp"
    cidr_blocks = [hcp_hvn.demostack.cidr_block,"0.0.0.0/0"]
  }

*/
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

