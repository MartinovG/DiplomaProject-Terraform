provider "aws" {
    region = local.region
}

data "aws_availability_zones" "available" {}

locals{
    name = "gm-diploma-project-vpc"
    region = "eu-central-1"

    name_short = "gm-dp-vpc"
    region_short = "euce1"

    vpc_cidr = "10.0.0.0/18"
    azs = slice(data.aws_availability_zones.available.names, 0, 3)

}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "6.5.1"

    name = local.name
    cidr = local.vpc_cidr
    azs = local.azs

    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnet_names = [
        "${local.name_short}-public-1-${local.region_short}",
        "${local.name_short}-public-2-${local.region_short}",
        "${local.name_short}-public-3-${local.region_short}"
    ]

    private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    private_subnet_names = [
        "${local.name_short}-private-1-${local.region_short}",
        "${local.name_short}-private-2-${local.region_short}",
        "${local.name_short}-private-3-${local.region_short}"
    ]

    database_subnets = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]

    create_database_subnet_group = true
    manage_default_network_acl = false
    manage_default_route_table = false
    manage_default_security_group = false

    enable_dns_hostnames = true
    enable_dns_support   = true

    enable_nat_gateway = true
    single_nat_gateway = true

    public_subnet_tags = {
        "kubernetes.io/role/elb" = 1
        "Tier" = "public"
    }

    private_subnet_tags = {
        "kubernetes.io/role/internal-elb" = 1
        "Tier" = "private"
    }
}

