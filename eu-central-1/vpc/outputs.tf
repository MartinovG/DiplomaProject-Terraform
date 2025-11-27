output "vpc_id" {
    description = "The ID of the VPC"
    value = module.vpc.vpc_id
}

output "vpc_arn" {
    description = "The ARN of the VPC"
    value = module.vpc.vpc_arn
}

output "vpc_cidr_block" {
    description = "The CIDR block of the VPC"
    value = module.vpc.vpc_cidr_block
}

output "default_security_group_id" {
    description = "The ID of the default security group"
    value = module.vpc.default_security_group_id
}

output "default_network_acl_id" {
    description = "The ID of the default network ACL"
    value = module.vpc.default_network_acl_id
}

output "default_route_table_id" {
    description = "The ID of the default route table"
    value = module.vpc.default_route_table_id
}

output "public_subnets" {
    description = "List of public subnet IDs"
    value = module.vpc.public_subnets
}

output "private_subnets" {
    description = "List of private subnet IDs"
    value = module.vpc.private_subnets
}

output "database_subnets" {
    description = "List of database subnet IDs"
    value = module.vpc.database_subnets
}

output "public_subnet_arns" {
    description = "List of public subnet ARNs"
    value = module.vpc.public_subnet_arns
}

output "private_subnet_arns" {
    description = "List of private subnet ARNs"
    value = module.vpc.private_subnet_arns
}

output "database_subnet_arns" {
    description = "List of database subnet ARNs"
    value = module.vpc.database_subnet_arns
}

output "public_subnets_cidr_blocks" {
    description = "List of public subnet CIDR blocks"
    value = module.vpc.public_subnets_cidr_blocks
}

output "private_subnets_cidr_blocks" {
    description = "List of private subnet CIDR blocks"
    value = module.vpc.private_subnets_cidr_blocks
}

output "database_subnets_cidr_blocks" {
    description = "List of database subnet CIDR blocks"
    value = module.vpc.database_subnets_cidr_blocks
}

output "natgw_ids" {
    description = "List of NAT Gateway IDs"
    value = module.vpc.natgw_ids
}
