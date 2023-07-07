resource "aws_codebuild_project" "this" {
  name           = "${var.environment}-${var.codebuild_project_name}"
  description    = "CodeBuild Project for ${var.codebuild_project_name}"
  build_timeout  = "60"
  queued_timeout = "60"
  service_role   = "arn:aws:iam::${var.account_id}:role/tfadmin"
  # service_role   = aws_iam_role.this.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_MEDIUM"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
    environment_variable {
      name  = "environment"
      value = var.environment #dev
    }
  }
  source {
    type            = "CODEPIPELINE"
    git_clone_depth = 0
  }
  vpc_config {
    vpc_id = var.vpc_id
    subnets = [
      var.subnet_id_0,
      var.subnet_id_1,
    ]
    security_group_ids = [
      var.security_group_id
    ]
  }
  tags = {
    Environment    = var.environment
    created_by = var.created_by_tag
  }
} 