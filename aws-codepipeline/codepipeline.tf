resource "aws_codepipeline" "main" {
  name = var.override_name == "" ? "${local.name}-pipeline" : "${var.override_name}-pipeline"
  role_arn = module.codepipeline_iam_role.arn

  artifact_store {
    location = module.codepipeline_bucket.bucket.id
    type = "S3"
  }
}