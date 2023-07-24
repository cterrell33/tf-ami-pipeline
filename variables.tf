variable "vpc_id" {
  type        = string
  default     = "vpc-02ee319ffb86c36b3"
  description = "VPC which must have a public and private subnet and igw"
}

variable "pipeline_name" {
  type        = string
  default     = "custom_ami"
  description = "VPC which must have a public and private subnet and igw"
}

variable "security_group_name" {
  type        = string
  default     = "custom_pipeline_sg"
  description = "Name of Security Group"
}

variable "codestar_connection_arn" {
  description = "CodeStar Connecton ARN"
  default     = "your code star"
  type        = string
}

variable "full_repository_id" {
  description = "This is the full repository id for what should be excuted in the pipeline"
  default     = "cterrell33/packer_ami"
  type        = string
}