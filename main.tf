locals {
  current_ip  = trimspace(chomp(data.http.current_ip.response_body))
  cidr_blocks = distinct(concat(var.cidr_blocks, var.allow_current_ip ? ["${local.current_ip}/32"] : []))
  subnet_id   = var.subnet_id != "" ? var.subnet_id : element(data.aws_subnets.public[0].ids.*, 0)
  ami         = var.ami != "" ? var.ami : data.aws_ami.amazon_linux_2.id
  merged_tags = merge({ "Terraform" = true, "Name" = var.name }, var.extra_tags)
}

resource "aws_key_pair" "bastion_host" {
  count = var.key_name != "" ? 0 : 1

  key_name   = lookup(var.create_public_key, "key_name", var.name)
  public_key = file(pathexpand(lookup(var.create_public_key, "key_filename", pathexpand("~/.ssh/id_rsa.pub"))))
}

resource "aws_security_group" "bastion_host" {
  name   = var.name
  vpc_id = var.vpc_id

  description = "Security group for bastion ${var.name}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.tcp_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = local.cidr_blocks
    }
  }

  tags = local.merged_tags

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_instance" "bastion_host" {
  ami           = local.ami
  instance_type = var.instance_type

  key_name = var.key_name != "" ? var.key_name : aws_key_pair.bastion_host[0].key_name

  subnet_id              = local.subnet_id
  vpc_security_group_ids = [aws_security_group.bastion_host.id]

  associate_public_ip_address = true

  tags        = local.merged_tags
  volume_tags = local.merged_tags
}
