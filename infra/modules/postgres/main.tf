locals {
    tags = {
        terraform   = "true"
        environment = var.environment
        module_name = "postgres_rds"
        directorate = "Software Group"
        team        = "0-3 Year Innovation"
        project     = "UKDS GeoConvert"
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
    name    = "geoconvert_db_password_${var.environment}"
    type    = "String"
    value   = var.db_password
}

resource "aws_db_instance" "default" {
    allocated_storage                     = 300
    storage_type                          = "gp2"
    engine                                = "postgres"
    engine_version                        = "12.4"
    instance_class                        = "db.t3.small"
    identifier                            = var.db_name
    name                                  = var.db_name
    username                              = "postgres"
    password                              = var.db_password
    publicly_accessible                   = var.publicly_accessible
    parameter_group_name                  = "postgres12-maxwalsize"
    vpc_security_group_ids  = [aws_security_group.ukds_geoconvert_database_security_group.id]
    db_subnet_group_name    = aws_db_subnet_group.ukds_geoconvert_database_subnet.name
    vpc_security_group_ids                = [aws_security_group.ukds_geoconvert_database_security_group.id]
    db_subnet_group_name                  = aws_db_subnet_group.ukds_geoconvert_database_subnet.name
    tags = {
        name        = var.db_name
        terraform   = "true"
        environment = var.environment
        module_name = "postgres_rds"
        directorate = "Software Group"
        team        = "0-3 Year Innovation"
        project     = "UKDS GeoConvert"
    }
}