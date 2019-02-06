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

## If you are using eksctl instead...
You can run `kube2iam` as a standalone submodule
to deploy the correct IAM roles and attachments
for kube2iam.

1. Go to the kube2iam submodule.
   ```
   cd kube2iam
   ```
1. Create a `.tfvars` file with the variables
   in `variables.tf`. You'll need the worker
   Role ARN and name.
1. `terraform plan -var-file=your.tfvars`
1. `terraform apply -var-file=your.tfvars`