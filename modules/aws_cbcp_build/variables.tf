
#variable "security_group_id" {
#  description = "Security Group ID"
#  type        = string
#}

variable "pipeline_name" {
  description = "CodePipeline Pipeline name"
  type        = string
}

variable "codestar_connection_arn" {
  description = "CodeStar Connecton ARN"
  default     = "arn:aws:codestar-connections:us-east-1:949588328828:connection/275aa982-0ded-4841-b3c5-35e4867bf21b"
  type        = string
}

variable "full_repository_id" {
  description = "GitHub Full Repository ID"
  type        = string
}

variable "repo" {
  description = "GitHub Repository name"
  type        = string
}

variable "branch_name" {
  description = "GitHub Repository Branch Name"
  default     = "main"
  type        = string
}

variable "script" {
  description = "Script CodeBuild Project is executing"
  default     = "terragrunt-apply.sh"
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
