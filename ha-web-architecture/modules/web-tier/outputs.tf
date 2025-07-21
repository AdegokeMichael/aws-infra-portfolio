output "web_asg_name" {
	value = aws_autoscaling_group.this.name
}

output "web_sg_id" {
	value = aws_security_group.web_sg.id
}