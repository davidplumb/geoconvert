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

variable "vpc_id" {
    type = string
}

variable "allowable_ips" {
    type = list(string)
}

variable "publicly_accessible" {
    type = bool
}