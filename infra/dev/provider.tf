provider "aws" {
    version = "3.5.0"
    region = "eu-west-1"
    profile = "ukds-geoconvert"
}

terraform {
    backend "s3" {
        bucket                  = "ukds-geoconvert-tfstate-dev"
        key                     = "terraform.tfstate"
        region                  = "eu-west-1"
        profile                 = "ukds-geoconvert"
    }
}