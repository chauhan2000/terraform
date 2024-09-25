variable "project_name" {
  description = "Name of the Project"
  default     = "Mastklub"
}

variable "vpc_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "additional_tags" {
  description = "Addtional tags needed for the resources"
  type        = map(string)
}

variable "vpc_cidr" {
  description = "The CIDR range of the VPC"
}

variable "environment" {
  description = "Environment in which resources are getting proviosioned"
}

variable "alb_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "A list of CIDR blocks for the app private subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "A list of CIDR blocks for the db private subnets"
  type        = list(string)
}

variable "index" {
  description = "Used for selection of subnet for NAT gateway"
  default = "1"
}