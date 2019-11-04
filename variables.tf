variable "vpc_id" {
  description = "VPC ID for the bastion host."
}

variable "name" {
  description = "Used in instance, security group, keypair naming, defaults to 'bastion-host'"
  default     = "bastion-host"
}

variable "subnet_id" {
  description = "Subnet ID to launch bastion host in, if not provided, 'subnet_tags' is used to discover."
  default     = ""
}

variable "subnet_tags" {
  description = "Mapping of tags to discover the public subnet, defaults to { Tier = 'Public' }, see https://www.terraform.io/docs/providers/aws/d/subnet_ids.html#tags"
  type        = map(string)
  default = {
    Tier = "Public"
  }
}

variable "tcp_ports" {
  description = "List of TCP ports to allow in security group, defaults to [22]"
  type        = list(number)
  default     = [22]
}

variable "cidr_blocks" {
  description = "CIDR blocks to add to bastion host security group, defaults to []."
  type        = list(string)
  default     = []
}

variable "allow_current_ip" {
  description = "If true, current IP (from https://ipv4.icanhazip.com/) will be allowed on 'tcp_ports', defaults to true."
  default     = true
}

variable "ami" {
  description = "AMI to launch, if not provided, default is Amazon Linux 2 AMI latest."
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type, defaults to t3.nano."
  default     = "t3.nano"
}

variable "key_name" {
  description = "EC2 keypair name to start the instance with. Either this or 'create_public_key' variable is required."
  default     = ""
}

variable "create_public_key" {
  description = "Map of public public key_name and key_filename to create an EC2 key from, eg. { key_name = 'foo', key_filename = '<some-path>' }. Either this or 'key_name' variable is required. Last resort is using '~/.ssh/id_rsa.pub'."
  type        = map(string)
  default     = {}
}

variable "extra_tags" {
  description = "Map of extra tags to add to resources, eg. { Environment = 'dev' }. Defaults to {}. Terraform='true' and Name tags are added automatically."
  type        = map(string)
  default     = {}
}
