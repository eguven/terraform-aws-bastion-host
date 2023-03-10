# terraform-aws-bastion-host

Terraform module which creates a bastion host resource on AWS. Requires Terraform >= 0.12.

## Minimal Example

The following will create a t3.nano instance in given VPC using latest Amazon Linux 2 AMI. When not provided:

* keypair will be created from `~/.ssh/id_rsa.pub`
* subnet will be discovered using `Tier = "Public"` tag
* security group will allow SSH on the current ip

```terraform
module "my_bastion_host" {
  source = "git@github.com:eguven/terraform-aws-bastion-host.git?ref=master"
  # The only required attribute is vpc_id
  vpc_id = "vpc-1337ffff1337ffff0"
}
```

## Config Snippets

```terraform
module "my_bastion_host" {
  source = "git@github.com:eguven/terraform-aws-bastion-host.git?ref=master"

  vpc_id = "vpc-1337ffff1337ffff0"

  # change name from bastion-host
  name = "jumphost"

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allow\_current\_ip | If true, current IP (from https://ipv4.icanhazip.com/) will be allowed on var.tcp_ports, defaults to true. | string | `true` | no |
| ami | AMI to launch, if not provided, default is Amazon Linux 2 AMI latest. | string | `""` | no |
| cidr\_blocks | CIDR blocks to add to bastion host security group, defaults to []. | list | `[]` | no |
| extra\_security\_group\_ids | Additional SGs to attach to instance, defaults to []. | list | `[]` | no |
| create\_public\_key | Map of public public key_name and key_filename to create an EC2 key from, eg. `{ key_name = 'foo', key_filename = '<some-path>' }`. Either this or 'key_name' variable is required. Last resort is using '~/.ssh/id_rsa.pub'. | map | `{}` | no |
| extra\_tags | Map of extra tags to add to resources, eg. `{ Environment = 'dev' }`. Defaults to {}. Terraform='true' and Name tags are added automatically. | map | `{}` | no |
| instance\_type | EC2 instance type, defaults to t3.nano. | string | `"t3.nano"` | no |
| key\_name | EC2 keypair name to start the instance with. Either this or 'create_public_key' variable is required. | string | `""` | no |
| name | Used in instance, security group, keypair naming, defaults to 'bastion-host' | string | `"bastion-host"` | no |
| subnet\_id | Subnet ID to launch bastion host in, if not provided, subnet_tags is used to discover. | string | `""` | no |
| subnet\_tags | Mapping of tags to discover the public subnet, defaults to `{ Tier = 'Public' }`, see https://www.terraform.io/docs/providers/aws/d/subnet_ids.html#tags | map | `{ Tier = 'Public' }` | no |
| tcp\_ports | List of TCP ports to allow in security group, defaults to [22] | list | `[22]` | no |
| vpc\_id | VPC ID for the bastion host. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance | AWS Instance object, https://www.terraform.io/docs/providers/aws/r/instance.html |
| private\_ip | Private IP associated with the instance. |
| public\_ip | Public IP associated with the instance. |
