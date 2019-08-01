# terraform-aws-bastion-host

Terraform module which creates a bastion host resource on AWS.

## Minimal Example

The following will create a t3.nano instance in given VPC using latest Amazon Linux 2 AMI. When not provided:

* keypair will be created from `~/.ssh/id_rsa.pub`
* subnet will be discovered using `Tier = "Public"` tag
* security group will allow SSH on the current ip

```terraform
module "my_bastion_host" {
  source = "git@github.com:eguven/terraform-aws-bastion-host.git?ref=master"

  vpc_id = "vpc-1337ffff1337ffff0"
  environment = "foobar"
}
```

## Config Snippets

```terraform
module "my_bastion_host" {
  source = "git@github.com:eguven/terraform-aws-bastion-host.git?ref=master"

  vpc_id = "vpc-1337ffff1337ffff0"
  environment = "foobar"

  # change name suffix from bastion-host
  resource_name_suffix = "jumphost"

  # ami and instance type
  ami = "ami-aaaaaaaa"
  instance_type = "t3.large"

  # key_name can be provided and will take precedence
  key_name = "my-keypair-on-ec2"

  # or a new keypair can be created with given name and file
  create_public_key = {
    key_name = "new-keyname-on-ec2"
    key_filename = "~/.ssh/some_pubkey.pub"
  }

  # subnet id can be provided and will take precedence
  subnet_id = "subnet-ffffff"

  # or subnet tags can be used to discover public subnets
  subnet_tags = {
    SubnetTierTag = "Public"
  }

  # ports can be extended
  tcp_ports = [22, 12345]

  # cidr blocks can be provided
  cidr_blocks = ["123.45.67.89/32", "111.22.33.44/30"]
}
```
