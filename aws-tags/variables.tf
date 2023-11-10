variable "name" {
  type = string
}

variable "environment" {
  default = "dev"
  type = string
}

variable "project" {
  default = "dev"
  type = string
}

variable "service" {
  type = string
}

variable "creator" {
  default = "Terraform via CD Pipeline"
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "owner" {
  default = "Rohit Pandey"
  type = string
}