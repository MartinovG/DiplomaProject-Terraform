module "ecr_repos" {
    source  = "terraform-aws-modules/ecr/aws"
    version = "3.1.0"

    for_each = var.repository_names

    repository_name = each.value

    repository_force_delete = true

    repository_image_tag_mutability = "MUTABLE"

    repository_read_access_arns = [module.github-oidc.iam_role_arn]

    repository_lifecycle_policy = jsonencode({
        rules = [
            {
                rulePriority = 1
                description  = "Keep last 10 images"
                selection = {
                    tagStatus    = "untagged"
                    countType    = "imageCountMoreThan"
                    countNumber  = 10
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