variable "project" {
  default = "rohit-pandey-project"
  type = string
}

variable "service" {
  type = string
}

variable "environment" {
  type = "string"
}

variable "override_name" {
  default = null
  type = string
}

variable "override_policy_name" {
  type = string
  default = null
}

variable "policy_document" {
  default = false
  type = any
}

variable "assume_role_policy" {
  default = ""
  type = string
}

variable "service_pricipals" {
  type = list(string)
  default = []
}

variable "managed_policies" {
  type = list(string)
  default = []
}

variable "max_session_duration" {
  type = number
  default = 3600
}

variable "permissions_boundry" {
  type = string
  description = "The name of permisson bound attached to the role"
  default = "AWS_BOM_POL_CustomRolePermissionBoundry"
}


variable "permissions_boundary_arn" {
  type = string
  default = ""
}

variable "tags_override" {
  type = map(string)
  default = {}
}

variable "trust_conditions" {
  default = []
  type = list(any)
}

variable "aws_principals" {
  default = []
  type = list(string)
}



















