output "aws_codebuild_project" {
    value   = aws_codebuild_project.this.arn
    description = "CodeBuild Name"
}