data "http" "current_ip" {
  url = "https://ipv4.icanhazip.com/"
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "public" {
  count = var.subnet_id != "" ? 0 : 1

  vpc_id = data.aws_vpc.vpc.id
  tags   = var.subnet_tags
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}