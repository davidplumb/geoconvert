locals {
    tags = {
        Name = "bastion_${var.environment}"
        Terraform   = "true"
        Environment = var.environment
        module_name = "postgres_rds"
        directorate = "Software Group"
        team        = "0 - 3 Year Innovation"
        Project     = "UKDS GeoConvert"
    }
}

resource "aws_security_group" "ec2_sg" {
    name    = "ec2-sg"
    vpc_id  = var.vpc_id
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
        protocol    = "-1"
    }
}

resource "aws_instance" "bastion" {
    ami                     = "ami-0bb3fad3c0286ebd5"
    instance_type           = "t2.nano"
    subnet_id               = var.public_subnet
    vpc_security_group_ids  = [aws_security_group.ec2_sg.id]
    key_name                = var.ec2_key_name
    
    tags = local.tags
}

resource "aws_eip" "bastion_ec2_elastic_ip" {
    instance = aws_instance.bastion.id
    vpc = true
}