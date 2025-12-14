locals {
    name = "gmDiplomaProject"
    cluster_version = "1.34"
    region = var.aws_region
    region_short = "euce1"

    azs = slice(data.aws_availability_zones.available.names, 0, 3)

    tags = {
        Terraform = "true"
    }
}

module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "21.10.1"

    name = local.name
    kubernetes_version = local.cluster_version
    endpoint_private_access = true
    endpoint_public_access = true
    enable_irsa = true

    enable_cluster_creator_admin_permissions = true

    addons = {
        vpc-cni = {
            before_compute = true
            #service_account_role_arn = module.vpc_cni_irsa.iam_policy_arn
            most_recent = true
        }
        kube-proxy = {
            resolve_conflicts_on_update = "PRESERVE"
            resolve_conflicts_on_create = "OVERWRITE"
            most_recent = true
        }
        coredns = {
            resolve_conflicts_on_update = "PRESERVE"
            resolve_conflicts_on_create = "OVERWRITE"
            most_recent = true
        }
    }

    vpc_id = data.aws_vpc.current.id
    subnet_ids = data.aws_subnets.eks_private.ids

    node_security_group_additional_rules = {
        ingress_self_all = {
            description = "Allow all traffic from within the security group"
            from_port = 0
            to_port = 0
            protocol = "-1"
            type = "ingress"
            self = true
        }
        ingress_vpc = {
            description = "Allow all traffic from within the VPC"
            from_port = 0
            to_port = 0
            protocol = "-1"
            type = "ingress"
            cidr_blocks = [data.aws_vpc.current.cidr_block]
        }
    }

    eks_managed_node_groups = {
        controllers = {
            ami_type = "AL2023_x86_64_STANDARD"

            iam_role_attach_cni_policy = true
            attach_cluster_primary_security_group = true
        
            min_size = 2
            max_size = 2
            desired_size = 2

            instance_types = ["t3.medium"]
        }
    }

    node_security_group_tags = {
        "karpenter.sh/discovery" = "gmDiplomaProject"
    }
}