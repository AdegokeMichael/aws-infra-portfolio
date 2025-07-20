variable "name" {}
variable "vpc_id" {}
variable "private_subnet_id" {
	type = list(string)
}

variable "alb_sg_id" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
