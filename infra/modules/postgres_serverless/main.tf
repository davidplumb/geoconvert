locals {
    tags = {
        Terraform   = "true"
        Environment = var.environment
        module_name = "postgres_rds"
        directorate = "Software Group"
        team        = "0-3 Year Innovation"
        Project     = "UKDS GeoConvert"
    }
}

resource "aws_db_subnet_group" "ukds_geoconvert_database_subnet" {

    name       = "ukds_geoconvert_database_subnet"
    subnet_ids = toset(var.vpc_subnet_ids)

    tags = local.tags
}

resource "aws_security_group" "ukds_geoconvert_database_security_group" {

    name        = "ukds_geoconvert_database_security_group"
    description = "ukds_geoconvert_database_security_group"
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

resource "aws_rds_cluster" "default" {
    cluster_identifier      = var.db_name
    vpc_security_group_ids  = [aws_security_group.ukds_geoconvert_database_security_group.id]
    db_subnet_group_name    = aws_db_subnet_group.ukds_geoconvert_database_subnet.name
    engine_mode             = "serverless"
    engine                  = "aurora-postgresql"
    master_username         = "postgres"
    master_password         = var.db_password
    backup_retention_period = 7
    skip_final_snapshot     = true

    scaling_configuration {
        auto_pause               = true
        max_capacity             = var.max_capacity
        min_capacity             = var.min_capacity
        seconds_until_auto_pause = 43200
    }

    tags = local.tags
}