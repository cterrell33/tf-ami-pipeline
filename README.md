# tf-ami-pipeline

The purpose of this repo serves as deploying a pipeline for building out a custom ami 

Prerequisites:
- Set up a codestar connection - https://docs.aws.amazon.com/codestar-connections/latest/APIReference/Welcome.html
- Additional repository which CodeBuild will run (i.e. https://github.com/cterrell33/packer_ami)

Note:
*This template needs to be use in conglomerate with another repo which will be used for CodeBuild , if not this will only deploy the codepipeline & codebuild but nothing will actually run* 

1. Complete variables for your needed environment see variables.tf in the root directory
    - Pipeline Name
    - Full repository ID - this will be the code that your pipeline will excute in a code build project
    - codestar conneciton - osn approves codestar but this arn changes with environment
    - Security Group Name
    - Vpc ID

2. Once the variables are complete run the following:
    - terraform init
    - terraform plan
    - terraform apply 

3. The following resources will be deployed:
    - Security Group
    - CodeBuild Project
    - CodePipeline
    - S3 Bucket
    - IAM Role
    - IAM Policy