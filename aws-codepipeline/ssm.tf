resource "aws_ssm_parameter" "pipeline" {
  # checkov:skip=CKV2_AWS_34: KMS cost money using default encryption
  name = "${var.ssm_base_path}/${aws_codepipeline.main.name}"
  type = "String"
  value = aws_codepipeline.main.name
  tags = module.tgs_ssm.tags
  key_id = "alias/aws/ssm"
}