module "codebuild_cd_iam_role" {
  source = "../aws-iam-role"
  project = var.project
  service = "${var.service}-codepipeline"
  environment = var.environment
  assume_role_policy = data.aws_iam_policy_document.codepipeline_trust_policy_document.json
  policy_document = data.aws_iam_policy_document.codepipeline_policy_document.json
  service_pricipals = ["codepipeline.amazonaws.com"]
  permissions_boundry = data.aws_iam_policy.permissions_boundary.name
  tags_override = module.tags_iam.tags
}
