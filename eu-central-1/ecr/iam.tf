data "aws_iam_policy_document" "oidc_policy" {
    statement {
        actions = [
            "ecr:GetRepositoryPolicy",
            "ecr:BatchCheckLayerAvailability",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:DescribeImages",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:BatchGetImage",
            "ecr:CompleteLayerUpload",
            "ecr:PutImage",
        ]

        resources = [for repo in module.ecr_repos : repo.repository_arn]
    }

    statement {
        actions = [
            "ecr:GetAuthorizationToken",
        ]
        resources = ["*"]
    }
}

