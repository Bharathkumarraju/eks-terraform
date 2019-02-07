terraform {
  required_version = ">= 0.11.8"
  backend "s3" {
    bucket = "${var.state_bucket}"
    key    = "${var.cluster_name}/"
    region  = "${var.state_bucket_region}"
  }
}

provider "aws" {
  version = ">= 1.47.0"
  region  = "${var.region}"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "alpha"

  worker_groups = [
    {
      # This will launch an autoscaling group with only On-Demand instances
      instance_type        = "t2.small"
      additional_userdata  = "echo foo bar"
      subnets              = "${join(",", module.vpc.private_subnets)}"
      asg_desired_capacity = "2"
    },
  ]
  worker_groups_launch_template = [
    {
      # This will launch an autoscaling group with only Spot Fleet instances
      instance_type                            = "t2.small"
      additional_userdata                      = "echo foo bar"
      subnets                                  = "${join(",", module.vpc.private_subnets)}"
      additional_security_group_ids            = ""
      override_instance_type                   = "t3.small"
      asg_desired_capacity                     = "2"
      spot_instance_pools                      = 10
      on_demand_percentage_above_base_capacity = "0"
    },
  ]
  tags = {
    Environment = "${local.cluster_name}"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
    Workspace   = "${terraform.workspace}"
  }
}

module "vpc" {
  source             = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git"
  version            = "1.14.0"
  name               = "${local.cluster_name}-vpc"
  cidr               = "10.0.0.0/16"
  azs                = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}", "${data.aws_availability_zones.available.names[2]}"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
  tags               = "${merge(local.tags, map("kubernetes.io/cluster/${local.cluster_name}", "shared"),map("kubernetes.io/role/elb", "1"))}"
}

module "eks" {
  source                               = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git"
  cluster_name                         = "${local.cluster_name}"
  subnets                              = ["${module.vpc.private_subnets}"]
  tags                                 = "${local.tags}"
  vpc_id                               = "${module.vpc.vpc_id}"
  worker_groups                        = "${local.worker_groups}"
  worker_groups_launch_template        = "${local.worker_groups_launch_template}"
  worker_group_count                   = "1"
  worker_group_launch_template_count   = "1"
  worker_additional_security_group_ids = []
  map_roles                            = "${var.map_roles}"
  map_roles_count                      = "${var.map_roles_count}"
  map_users                            = "${var.map_users}"
  map_users_count                      = "${var.map_users_count}"
  map_accounts                         = "${var.map_accounts}"
  map_accounts_count                   = "${var.map_accounts_count}"
}

module "kube2iam" {
  source = "./kube2iam"
  region = "${var.region}"
  add_kube2iam = true
  eks_worker_iam_role_arn = "${module.eks.worker_iam_role_arn}"
  eks_worker_iam_role_name = "${module.eks.worker_iam_role_name}"
}
