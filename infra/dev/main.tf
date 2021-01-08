locals {
    environment             = "dev"
    project                 = "GeoConvert"
    aws_region              = "eu-west-1"
    db_name                 = "ukdsgeoconvertdev"
    db_allocated_storage    = 200
    db_instance_class       = "db.t2.small"
    ec2_key_name            = "ukds"
    allowable_ips           = [
        "193.62.83.114/32",     // vpn
        "193.62.83.115/32",     // vpn
        "194.81.3.15/32",       // vpn
        "194.81.3.16/32",       // vpn
        "10.10.1.0/24",          // Private Subnet
        "10.10.2.0/24",          // Private Subnet
        "10.10.3.0/24",          // Private Subnet
        "10.10.101.0/24",        // Public Subnet
        "10.10.102.0/24",        // Public Subnet
        "10.10.103.0/24"         // Public Subnet
    ]
    database_subnets = [
        "10.10.30.0/24",
        "10.10.31.0/24",
        "10.10.32.0/24"
    ]
}

data "aws_availability_zones" "available" {}

resource "random_id" "random_16" {
    byte_length = 16 * 3/4
}

module "network" {
    source              = "../modules/network"
    cidr_block          = "10.10.0.0/16"
    public_subnets      = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
    private_subnets     = ["10.10.100.0/24", "10.10.101.0/24", "10.10.102.0/24"]
    azs = data.aws_availability_zones.available.names
    environment = local.environment
}

## no need for bastion here as the dev db is not in a private subnet
# module "bastion_ec2" { 
#     source          = "../modules/bastion"
#     public_subnet   = module.vpc.public_subnets[0]
#     vpc_id          = module.vpc.vpc_id
#     environment     = local.environment
#     ec2_key_name    = local.ec2_key_name
# }

module "postgres" {
    source                  = "../modules/postgres"
    db_password             = random_id.random_16.b64_url
    db_name                 = local.db_name
    vpc_subnet_ids          = module.network.public_subnet_ids
    environment             = local.environment
    vpc_id                  = module.network.vpc_id
    allowable_ips           = local.allowable_ips
    publicly_accessible     = true
}