resource "aws_security_group" "web_sg" {
	name = "${var.name}-web-sg"
	description = "Allow HTTP from ALB only"
	vpc_id = var.vpc_id

	ingress {
	    from_port = 80
	    to_port = 80
	    protocol = "tcp"
	    security_groups = [var.alb_sg_id]
	}

	egress {
	    from_port = 0
	    to_port = 0
	    protocol = "-1"
	    cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
	    Name = "${var.name}-web-sg"
	}
}

resource "aws_launch_template" "this" {
	name_prefix = "${var.name}-lt"
	image_id = var.ami_id
	instance_type = var.instance_type
	key_name = var.key_name

	network_interfaces {
	    associate_public_ip_address = false
	    security_groups = [aws_security_group.web_sg.id]
	}

	tag_specifications  {
	    resource_type = "instance"
	    tags = {
	        Name = "${var.name}-web"
	    }

	}
}


resource "aws_auto_caling_group" "this" {
	vpc_zone_identifier = var.private_subnet_ids
	desired_capacity = 2
	max_size = 3
	min_size = 1
	health_check_type = "EC2"

	launch_template {
	    id = aws_launch_template.this.id
	    version = "$Latest"
	}

	tag = {
	    key = "Name"
	    value = "${var.name}-web-asg"
	    propagate_at_launch = true
	}
}