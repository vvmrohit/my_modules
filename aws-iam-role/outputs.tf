output "arn" {
    value = aws_iam_role.default.arn
}

output "name" {
  value = aws_iam_role.default.name
}

output "policy_arn" {
  value = var.policy_document == false ? "No policy attached" : aws_iam_policy.default[0].arn
}