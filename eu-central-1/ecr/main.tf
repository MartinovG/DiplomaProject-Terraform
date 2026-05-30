module "ecr_repos" {
    source  = "terraform-aws-modules/ecr/aws"
    version = "3.1.0"

    for_each = var.repository_names

    repository_name = each.value

    repository_image_tag_mutability = "IMMUTABLE"

    repository_read_access_arns = [module.github-oidc.iam_role_arn]

    repository_lifecycle_policy = jsonencode({
        rules = [
            {
                rulePriority = 1
                description  = "Expire PR preview images after 14 days"
                selection = {
                    tagStatus     = "tagged"
                    tagPrefixList = ["backend-pr-", "frontend-pr-"]
                    countType     = "sinceImagePushed"
                    countUnit     = "days"
                    countNumber   = 14
                }
                action = {
                    type = "expire"
                }
            },
            {
                rulePriority = 2
                description  = "Keep last 30 prod (SHA-tagged) images"
                selection = {
                    tagStatus     = "tagged"
                    tagPrefixList = ["backend-sha-", "frontend-sha-"]
                    countType     = "imageCountMoreThan"
                    countNumber   = 30
                }
                action = {
                    type = "expire"
                }
            },
            {
                rulePriority = 3
                description  = "Expire untagged images after 1 day"
                selection = {
                    tagStatus   = "untagged"
                    countType   = "sinceImagePushed"
                    countUnit   = "days"
                    countNumber = 1
                }
                action = {
                    type = "expire"
                }
            }
        ]
    })

    tags = {
        Environment = "prod"
        Project     = "DiplomaProject"
        region      = "eu-central-1"
        Terraform   = "true"
    }
}