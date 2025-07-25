output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "db_endpoint" {
  value = module.db.db_endpoint
}
