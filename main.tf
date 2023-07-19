data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "private" {
  filter {
    name  = "vpc-id"
    values = [var.vpc_id]
  }
  tags = {
    Tier = "Private"
  }
}
provider "aws" {
  region = "us-east-1"
}

module "aws_security_group" {
  source              = "./modules/aws_security_group"
  security_group_name = "Custom_AMI"
  vpc_id              = data.aws_vpc.selected.id
}

module "aws_cbcp_build" {
  source                 = "./modules/aws_cbcp_build"
  pipeline_name          = "Build_Custom_AMI"
  full_repository_id     = "cterrell33/packer_ami"
  codebuild_project_name = "Build_Custom_AMI"
  vpc_id                 = data.aws_vpc.selected.id
  subnets                = data.aws_subnets.private.ids
  security_group_id      = module.aws_security_group.id
  depends_on = [
    module.aws_security_group
  ]
}