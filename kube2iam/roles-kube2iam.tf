resource "aws_iam_policy" "kube2iam_policy" {
  count = "${var.add_kube2iam ? 1 : 0}"
  name = "Kube2IAMPolicy"
  description = "Kube2IAM IAM Policy for Role Assumption"
  policy      = "${file("policy/kube2iam.json")}"
}

resource "aws_iam_role_policy_attachment" "workers_assumerole_policy" {
  count = "${var.add_kube2iam ? 1 : 0}"
  role = "${var.eks_worker_iam_role_name}"
  policy_arn = "${aws_iam_policy.kube2iam_policy.arn}"
}