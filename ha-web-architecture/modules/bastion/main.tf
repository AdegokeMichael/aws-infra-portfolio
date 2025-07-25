resource "aws_security_group" "bastion_sg" {
	name = "${var.name}-bastion-sg"
	description = "Allow ssh access"
	vpc_id = var.vpc_id


	ingress {
	    from_port = 22
	    to_port = 22
	    protocol = "tcp"
	    cidr_blocks = [var.allowed_ssh_cidr] 
	}

	egress {
	    from_port = 0
	    to_port = 0
	    protocol = "-1"
	    cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
	    Name = "${var.name}-bastion-sg"
	}
}

resource "aws_instance" "bastion" {
	ami = var.ami_id
	instance_type = var.instance_type
	subnet_id = var.subnet_id
	key_name = var.key_name
	vpc_security_group_ids = [aws_security_group.bastion_sg.id]
	associate_public_ip_address = false

	tags = {
        Name = "${var.name}-bastion"
	}

}

#Elastic IP
resource "aws_eip" "bastion" {
  domain = "vpc"
}


resource "aws_eip_association" "this" {
	instance_id = aws_instance.bastion.id
	allocation_id = aws_eip.bastion.id
}
