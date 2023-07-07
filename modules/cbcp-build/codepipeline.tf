resource "aws_codepipeline" "codepipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"

    encryption_key {
      id   = data.aws_kms_alias.s3kmskey.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestar_connection_arn
        FullRepositoryId = var.full_repository_id
        BranchName       = var.branch_name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy_Terraform"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      # output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${var.environment}-${var.codebuild_project_name}"
        EnvironmentVariables = jsonencode([
          {
            name  = "SCRIPT"
            value = var.script
            type  = "PLAINTEXT"
          },
          {
            name  = "PREP"
            value = var.prep
            type  = "PLAINTEXT"
          },
          {
            name  = "ENV"
            value = var.environment
            type  = "PLAINTEXT"
          },
          {
            name  = "REPO"
            value = var.repo
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.environment}-codepipeline-artifacts-${random_id.this.hex}"

  tags = {
    created_by    = var.created_by_tag
    o_Environment = var.o_environment
    o_Project     = var.o_project
    Owner         = var.owner
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.this]
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}

data "aws_kms_alias" "s3kmskey" {
  name  = "alias/aws/s3"
}

resource "random_id" "this" {
  byte_length = 8
}