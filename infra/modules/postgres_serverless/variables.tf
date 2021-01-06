variable "environment" {
    type = string
}

variable "db_name" {
    type = string
}

variable "vpc_subnet_ids" {
    type = list(string)
}

variable "db_password" {
    type = string
}

variable "max_capacity" {
    type = number
}

variable "min_capacity" {
    type = number
}

variable "vpc_id" {
    type = string
}

variable "allowable_ips" {
    type = list(string)
}