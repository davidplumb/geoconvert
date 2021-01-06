provider "aws" {
    version = "3.5.0"
    region = "eu-west-1"
    profile = "ukds-census-platform"
}

terraform {
    backend "s3" {
        bucket                  = "ukds-census-tfstate-dev"
        key                     = "terraform.tfstate"
        region                  = "eu-west-1"
        profile                 = "ukds-census-platform"
    }
}