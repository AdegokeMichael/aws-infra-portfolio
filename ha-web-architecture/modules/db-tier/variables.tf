variable "name" {}
variable "vpc_id" {}
variable "private_subnet_id" {
	type = list(string)
}
variable "web_sg_id" {}
variable "db_username" {}
variable "db_password" {}
variable "azs" {
	type = list(string)
}

