locals {
    tags = {
        Terraform   = "true"
        Environment = var.environment
        module_name = "postgres_rds"
        directorate = "Software Group"
        team        = "0 - 3 Year Innovation"
        Project     = "UKDS Census Platform"
    }
}

resource "aws_db_subnet_group" "ukds_census_platform_database_subnet" {

    name       = "ukds_census_platform_database_subnet"
    subnet_ids = toset(var.vpc_subnet_ids)

    tags = local.tags
}

resource "aws_security_group" "ukds_census_platform_database_security_group" {

    name        = "ukds_census_platform_database_security_group"
    description = "ukds_census_platform_database_security_group"
    vpc_id      = var.vpc_id

    ingress {
        description = "Access from VPN"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = var.allowable_ips
    }

    tags = local.tags
}

resource "aws_ssm_parameter" "db_password" {
    name    = "db_password_${var.environment}"
    type    = "String"
    value   = var.db_password
}

resource "aws_db_instance" "default" {
    allocated_storage    = 300
    storage_type         = "gp2"
    engine               = "postgres"
    engine_version       = "12.4"
    instance_class       = "db.t2.small"
    name                 = var.db_name
    username             = "postgres"
    password             = var.db_password
    publicly_accessible  = var.publicly_accessible

    vpc_security_group_ids  = [aws_security_group.ukds_census_platform_database_security_group.id]
    db_subnet_group_name    = aws_db_subnet_group.ukds_census_platform_database_subnet.name
    tags = {
        Name        = var.db_name
        Terraform   = "true"
        Environment = var.environment
        module_name = "postgres_rds"
        directorate = "Software Group"
        team        = "0 - 3 Year Innovation"
        Project     = "UKDS Census Platform"
    }
}