resource "aws_iam_policy" "ingresscontroller_policy" {
  count = "${var.add_ingress_policy ? 1 : 0}"
  name = "IngressController-Policy"
  description = "IngressController IAM Policy"
  policy      = "${file("policy/alb-ingress-controller.json")}"
}

resource "aws_iam_role_policy_attachment" "workers_ingresscontroller_policy" {
  count = "${var.add_ingress_policy ? 1 : 0}"
  role = "${module.eks.worker_iam_role_name}"
  policy_arn = "${aws_iam_policy.ingresscontroller_policy.arn}"
}