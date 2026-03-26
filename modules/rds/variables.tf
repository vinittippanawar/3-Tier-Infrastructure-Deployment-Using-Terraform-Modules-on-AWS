variable "project_name" {
  description = "Project name"
  type        = string
}

variable "db_subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
}

variable "db_sg_id" {
  description = "Database Security Group ID"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}