resource "aws_security_group" "mastersg"{
    name        = "tfdemo_sg"
    vpc_id      = "vpc-02ee319ffb86c36b3"
    dynamic "ingress" {
        for_each = var.rules
        content {
            description     = ingress.value["description"]
            from_port       = ingress.value["from_port"]
            to_port         = ingress.value["to_port"]
            protocol        = ingress.value["protocol"]
            cidr_blocks     = ingress.value["cidr_blocks"]
        }
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["10.0.0.0/8"]
    }
}

###Pipeline role###
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.environment}-codepipeline-${random_id.this.hex}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  permissions_boundary = "arn:${var.partition}:iam::${var.account_id}:policy/ose.boundary.DeveloperFull"

  tags = {
    created_by = var.created_by_tag
  }
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
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}
