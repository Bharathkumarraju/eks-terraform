variable "region" {
  default = "us-west-2"
}
variable "eks_worker_iam_role_arn" {
  type = "string"
}
variable "eks_worker_iam_role_name" {
  type = "string"
}

variable "add_kube2iam" {
  default = false
}