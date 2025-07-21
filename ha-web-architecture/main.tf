module "vpc" {
  source               = "./modules/vpc"
  name                 = "ha-vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]

}

module "bastion" {
  source           = "./modules/bastion"
  name             = "personal"
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.public_subnets[0]
  ami_id           = var.ami_id
  instance_type    = "t3.micro"
  key_name         = var.key_name
  allowed_ssh_cidr = var.allowed_ssh_cidr

}

module "alb" {
  source            = "./modules/alb"
  name              = "personal"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets

}

module "web" {
  source             = "./modules/web-tier"
  name               = "personal"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  alb_sg_id          = module.alb.alb_sg_id
  ami_id             = var.ami_id
  instance_type      = "t3.micro"
  key_name           = var.key_name
}

module "db" {
  source              = "./modules/db-tier"
  name                = "personal"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnets
  web_sg_id           = module.web.web_sg_id
  db_username         = "admin"
  db_password         = "YourStrongPassword123"
  azs                 = ["us-east-1a", "us-east-1b"]
}


