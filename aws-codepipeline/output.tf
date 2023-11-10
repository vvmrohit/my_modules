output "role_arn" {
  value = module.codepipeline_iam_role.arn
}

output "pipeline_name" {
  value = aws_codepipeline.main.name
}

output "pipeline_arn" {
    value = aws_codepipeline.main.arn
}