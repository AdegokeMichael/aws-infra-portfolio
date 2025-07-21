resource "aws_security_group" "alb_sg" {
	name = "${var.name}-alg-sg"
	description = "Allow HTTP inbound from the internet"
	vpc_id = var.vpc_id

	ingress {
	    from_port = 80
	    to_port = 80
	    protocol = "tcp"
	    cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
	    from_port = 0
	    to_port = 0
	    protocol = "-1"
	    cidr_blocks = ["0.0.0.0/0"]

	}

	tags = {
	    Name = "${var.name}-alb-sg"
	}
} 

resource "aws_lb" "this" {
	name = "${var.name}-alb"
	internal = false
	load_balancer_type = "application"
	security_groups = [aws_security_group.alb_sg.id]
	subnets = var.public_subnet_ids

	tags = {
	    name = "${var.name}-alb"
	}
}

resource "aws_lb_target_group" "this" {
	name = "${var.name}-tg"
	port = 80
	protocol = "HTTP"
	vpc_id = var.vpc_id
	target_type = "instance"

	health_check {

	path = "/"
	protocol = "HTTP"
	matcher = "200"
	interval = 30
	timeout = 3
	healthy_threshold = 3
	unhealthy_threshold = 3
	} 

	tags = {
	    name = "${var.name}-tg"
	}
}

resource "aws_lb_listener" "this" {
	load_balancer_arn = aws_lb.this.arn
	port = 80
	protocol = "HTTP"

	default_action {
	    type = "forward"
	    target_group_arn = aws_lb_target_group.this.arn
	}
}