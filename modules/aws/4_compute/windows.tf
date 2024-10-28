#AMI Filter for Windows Server 2019 Base
data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "name"
    # values = ["Windows_Server-2019-English-Full-Base-*"]
     values = ["Windows_Server-2016-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  # owners = ["801119661308"] # Microsoft
owners = ["801119661308"] # Amazon
}

resource "aws_instance" "windows" {

  ami           = data.aws_ami.windows.id
  instance_type = var.instance_type_worker
  key_name      = var.aws_key_pair_id

  subnet_id              = var.subnet_ids[0]
  iam_instance_profile   = var.aws_iam_instance_profile_name
  vpc_security_group_ids = var.vpc_security_group_ids


  root_block_device {
    volume_size           = "240"
    delete_on_termination = "true"
  }

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size           = "240"
    delete_on_termination = "true"
  }


get_password_data = true
  user_data = base64encode(file("${path.module}/templates/windows/init.ps1"))
}