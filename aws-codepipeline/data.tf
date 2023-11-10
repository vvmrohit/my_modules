data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "github_token" {
    name = var.github_token_ssm_path
}

data "github_repository" "repo"{
    full_name = "${var.repository_owner}/${var.repository_name}"
}