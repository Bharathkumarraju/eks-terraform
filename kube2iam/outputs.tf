output "alb_controller_role_arn" {
  description = "ALB Controller Role ARN."
  value       = "${aws_iam_role.k8s_alb_controller_role.*.arn}"
}