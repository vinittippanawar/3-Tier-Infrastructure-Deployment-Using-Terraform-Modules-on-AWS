variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
}

variable "instance_name" {
  description = "Instance Name"
  type        = string
}

variable "associate_public_ip" {
  description = "Assign public IP"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "User data script"
  type        = string
}