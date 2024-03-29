resource "aws_codebuild_project" "this" {
  name           = var.codebuild_project_name
  description    = "CodeBuild Project for ${var.codebuild_project_name}"
  build_timeout  = "60"
  queued_timeout = "60"
  service_role   = aws_iam_role.codepipeline_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_MEDIUM"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
    environment_variable {
      name  = "environment"
      value = "dev" #dev
    }
  }
  source {
    type            = "CODEPIPELINE"
    git_clone_depth = 0
  }
  vpc_config {
    vpc_id = var.vpc_id
    subnets = var.subnets
    security_group_ids = [var.security_group_id]
  }
} 

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
      name             = "Build_AMI"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      run_order        = "1"  
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_project_name
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
            value = "dev"
            type  = "PLAINTEXT"
          }
        ])
      }
    }

    action {
      name             = "Validate_AMI"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      # output_artifacts = ["build_output"]
      version          = "1"
      run_order        = "2"

      configuration = {
        ProjectName = var.codebuild_project_name
        EnvironmentVariables = jsonencode([
          {
            name  = "SCRIPT"
            value = "validate-ami.sh"
            type  = "PLAINTEXT"
          },
          {
            name  = "ENV"
            value = "dev"
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }
  depends_on = [
  aws_codebuild_project.this
  ]
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "codepipeline-artifacts-${random_id.this.hex}"
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

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com","codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline-${random_id.this.hex}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]
    resources = [
      aws_s3_bucket.codepipeline_bucket.arn,
      "${aws_s3_bucket.codepipeline_bucket.arn}/*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:UseConnection"]
    resources = [var.codestar_connection_arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "*",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

data "aws_kms_alias" "s3kmskey" {
  name  = "alias/aws/s3"
}

resource "random_id" "this" {
  byte_length = 8
}