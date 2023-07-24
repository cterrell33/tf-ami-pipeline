data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "private" {
  filter {
    name  = "vpc-id"
    values = [var.vpc_id]
  }
}

provider "aws" {
  region = "us-east-1"
}

module "aws_security_group" {
  source              = "./modules/aws_security_group"
  security_group_name = var.security_group_name
  vpc_id              = data.aws_vpc.selected.id
}

module "aws_cbcp_build" {
  source                  = "./modules/aws_cbcp_build"
  pipeline_name           = var.pipeline_name
  full_repository_id      = var.full_repository_id
  codestar_connection_arn = var.codestar_connection_arn
  codebuild_project_name  = "Build_${var.pipeline_name}"
  vpc_id                  = data.aws_vpc.selected.id
  subnets                 = data.aws_subnets.private.ids
  security_group_id       = module.aws_security_group.id
  depends_on = [
    module.aws_security_group
  ]
}