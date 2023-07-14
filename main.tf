module "aws_security_group"{
  source = "github.com/cterrell33/tf-projects//modules/aws_security_group"
  security_group_name = "Made with Pipeline"
  vpc_id = "vpc-0e028ff8fd78c9404"
}

module "aws_cbcp_build"{
  source = "github.com/cterrell33/tf-projects//modules/aws_cbcp_build"
  security_group_name = "Made with Pipeline"
  vpc_id = "vpc-0e028ff8fd78c9404"
}