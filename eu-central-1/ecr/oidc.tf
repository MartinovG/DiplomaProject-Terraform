module "github-oidc" {
    source = "unfunco/oidc-github/aws"
    version = "2.0.2"

    github_repositories = [
        "MartinovG/DiplomaProject-Terraform:*",
        "MartinovG/DiplomaProject-App:*",
        "MartinovG/DiplomaProject-ArgoCD:*"
        ]

    iam_role_inline_policies = {
        github_oidc_policy = data.aws_iam_policy_document.oidc_policy.json
    }
}