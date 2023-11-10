locals {
  role_name            = var.override_name == null ? "role-${var.project}-${var.environment}-${var.service}" : var.override_name
  policy_name          = var.override_name == null ? "role-${var.project}-${var.environment}-${var.service}" : var.override_policy_name
  permissions_boundary = var.permissions_boundary_arn != "" ? var.permissions_boundary_arn : "arn:aws:iam::${module.common.aws_account_id}:policy/${var.permissions_boundry}"
}