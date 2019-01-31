# eks-terraform

## Pre-Requisites
* AWS CLI
* Terraform
* [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)

## Run
1. Set your AWS credentials as part of your environment.
1. Make sure your tfvars file defines everthing in `variables.tf`.
1. `terraform init`
1. `terraform plan -var-file=your.tfvars`
1. `terraform apply -var-file=your.tfvars`

## Using the Cluster
1. Make sure you have your AWS credentials set as part of your environment.
1. Run `kubectl cluster-info`