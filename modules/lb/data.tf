# data "aws_network_interface" "lb_names" {
#   count = var.nlb_arn == "" ? 0 : length(var.public_subnets)

#   filter {
#     name   = "description"
#     values = ["ELB ${var.nlb_arn}"]
#   }

#   filter {
#     name   = "subnet-id"
#     values = [var.public_subnets[count.index]]
#   }
# }

data "aws_elb_service_account" "main" {}
data "aws_caller_identity" "current" {}