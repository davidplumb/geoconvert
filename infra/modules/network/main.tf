resource "aws_vpc" "main" {
    cidr_block              = var.cidr_block
    enable_dns_support      = true
    enable_dns_hostnames    = true
    tags = {
        Name = "${var.environment}_geoconvert_vpc"
    }
}

resource "aws_subnet" "public_1" {
    vpc_id                          = aws_vpc.main.id
    cidr_block                      = var.public_subnets[0]       
    availability_zone               = var.azs[0]
    map_public_ip_on_launch         = false
    assign_ipv6_address_on_creation = false

    tags = {
        Name = "${var.environment}_geoconvert_public_subnet_1"
    }
}

resource "aws_subnet" "public_2" {
    vpc_id                          = aws_vpc.main.id
    cidr_block                      = var.public_subnets[1]       
    availability_zone               = var.azs[1]
    map_public_ip_on_launch         = false
    assign_ipv6_address_on_creation = false

    tags = {
        Name = "${var.environment}_geoconvert_public_subnet_2"
    }
}

resource "aws_subnet" "public_3" {
    vpc_id                          = aws_vpc.main.id
    cidr_block                      = var.public_subnets[2]       
    availability_zone               = var.azs[2]
    map_public_ip_on_launch         = false
    assign_ipv6_address_on_creation = false

    tags = {
        Name = "${var.environment}_geoconvert_public_subnet_3"
    }
}

resource "aws_subnet" "private_1" {
    vpc_id                          = aws_vpc.main.id
    cidr_block                      = var.private_subnets[0]
    availability_zone               = var.azs[0]
    map_public_ip_on_launch         = false
    assign_ipv6_address_on_creation = false

    tags = {
        Name = "${var.environment}_geoconvert_private_subnet_1"
    }
}

resource "aws_subnet" "private_2" {
    vpc_id                          = aws_vpc.main.id
    cidr_block                      = var.private_subnets[1]
    availability_zone               = var.azs[1]
    map_public_ip_on_launch         = false
    assign_ipv6_address_on_creation = false

    tags = {
        Name = "${var.environment}_geoconvert_private_subnet_2"
    }
}

resource "aws_subnet" "private_3" {
    vpc_id                          = aws_vpc.main.id
    cidr_block                      = var.private_subnets[2]
    availability_zone               = var.azs[2]
    map_public_ip_on_launch         = false
    assign_ipv6_address_on_creation = false

    tags = {
        Name = "${var.environment}_geoconvert_private_subnet_3"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
}

resource "aws_eip" "nat_eip" {
    vpc         = true
    depends_on  = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_1.id
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "public_1" {
    subnet_id      = aws_subnet.public_1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
    subnet_id      = aws_subnet.public_2.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_3" {
    subnet_id      = aws_subnet.public_3.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private_1" {
    subnet_id      = aws_subnet.private_1.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
    subnet_id      = aws_subnet.private_2.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_3" {
    subnet_id      = aws_subnet.private_3.id
    route_table_id = aws_route_table.private.id
}