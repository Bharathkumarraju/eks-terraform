resource "aws_iam_role" "k8s_alb_controller_role" {
  count = "${var.add_kube2iam ? 1 : 0}"
  name = "KubernetesALBControllerRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.eks_worker_iam_role_arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
      resource = "k8s-alb-controller"
  }
}
resource "aws_iam_policy" "ingresscontroller_policy" {
  count = "${var.add_kube2iam ? 1 : 0}"
  name = "IngressControllerPolicy"
  description = "IngressController IAM Policy"
  policy      = "${file("policy/alb-ingress-controller.json")}"
}

resource "aws_iam_role_policy_attachment" "workers_ingresscontroller_policy" {
  count = "${var.add_kube2iam ? 1 : 0}"
  role = "${var.eks_worker_iam_role_name}"
  policy_arn = "${aws_iam_policy.ingresscontroller_policy.arn}"
}