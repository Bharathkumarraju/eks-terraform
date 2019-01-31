resource "aws_iam_role" "kube2iam_assumeworker_role" {
  count = "${var.add_kube2iam_policy ? 1 : 0}"
  name = "AssumeWorkerRole"

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
        "AWS": "${module.eks.worker_iam_role_arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
      resource = "kube2iam"
  }
}

resource "aws_iam_policy" "kube2iam_policy" {
  count = "${var.add_kube2iam_policy ? 1 : 0}"
  name = "Kube2IAM-Policy"
  description = "Kube2IAM IAM Policy for Role Assumption"
  policy      = "${file("policy/kube2iam.json")}"
}

resource "aws_iam_role_policy_attachment" "workers_assumerole_policy" {
  count = "${var.add_kube2iam_policy ? 1 : 0}"
  role = "${module.eks.worker_iam_role_name}"
  policy_arn = "${aws_iam_policy.kube2iam_policy.arn}"
}