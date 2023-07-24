variable "vpc_id" {
  description = "vpc"
  type        = string
}

variable "subnets" {
  description = "subnets"
  type        = set(string)
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "pipeline_name" {
  description = "CodePipeline Pipeline name"
  type        = string
}

variable "codestar_connection_arn" {
  description = "CodeStar Connecton ARN"
  type        = string
}

variable "full_repository_id" {
  description = "GitHub Full Repository ID"
  type        = string
}

variable "branch_name" {
  description = "GitHub Repository Branch Name"
  default     = "main"
  type        = string
}

variable "script" {
  description = "Script CodeBuild Project is executing"
  default     = "build-ami.sh"
  type        = string
}

variable "prep" {
  description = "Installing pipeline dependencies..."
  default     = "install-dependencies.sh"
  type        = string
}

variable "codebuild_project_name" {
  description = "CodeBuild Project name"
  type        = string
}
