variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "ami_id" {
  description = "AMI for EC2 instances"
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair for SSH"
}

variable "allowed_ssh_cidr" {
  description = "Your home/public IP CIDR block to allow SSH (e.g., 1.2.3.4/32)"
}

variable "db_username" {
  description = "RDS database username"
  type        = string
}

variable "db_password" {
  description = "RDS database password"
  type        = string
}
