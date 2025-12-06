data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "current" {
    filter {
        name = "tag:Name"
        values = ["${var.vpc_name}"]
    }
}

data "aws_eks_cluster_auth" "cluster" {
    name = module.eks.cluster_name
}

data "aws_availability_zones" "available" {
    state = "available"
}

data "aws_subnets" "eks_private" {
    filter {
        name = "tag:Tier"
        values = ["private"]
    }

    filter {
        name = "vpc-id"
        values = [data.aws_vpc.current.id]
    }
}

data "aws_subnets" "eks_private_nodes" {
    filter {
        name = "tag:Name"
        values = ["${var.eks_private_nodes_subnet_names}"]
    }

    filter {
        name = "vpc-id"
        values = [data.aws_vpc.current.id]
    }
}