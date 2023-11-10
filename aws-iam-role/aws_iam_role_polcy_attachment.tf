resource "aws_iam_role_policy_attachment" "inline" {
  count      = var.policy_document == false ? 0 : 1
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.name
}

resource "aws_iam_role_policy_attachment" "managed" {
  count      = length(var.managed_policies)
  role       = aws_iam_role.default.name
  policy_arn = element(var.managed_policies, count.index)
}