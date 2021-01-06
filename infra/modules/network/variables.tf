variable "cidr_block" {
    type = string
}

variable "public_subnets" {
    type = list(string)
}

variable "private_subnets" {
    type = list(string)
}

variable "azs" {
  description = "the AZ names to use for the 3 subnets"
  type = list(string)  
}

variable "environment" {
    type = string
}