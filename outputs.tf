output "public_ip" {
  description = "Public IP associated with the instance."
  value       = aws_instance.bastion_host.public_ip
}

output "private_ip" {
  description = "Private IP associated with the instance."
  value       = aws_instance.bastion_host.private_ip
}

output "instance" {
  description = "AWS Instance object, https://www.terraform.io/docs/providers/aws/r/instance.html"
  value = aws_instance.bastion_host
}
