variable "name" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "allowed_ssh_cidr" {
	description = "CIDR block allowed to ssh into bastion (e.g your home IP)" 
}