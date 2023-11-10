resource "aws_ssm_parameter" "pipeline" {
  name = "${var.ssm_base_path}/${aws_codepipeline.main.name}"
  type = "String"
  value = aws_codepipeline.main.name
  tags = module.tgs_ssm.tags
}