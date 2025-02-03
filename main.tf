terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }

  backend "s3" {
    bucket = "my-tf-state-01022025"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "lambda_name" {
  type    = string
  default = "hello-lambda"
}

# data "aws_vpc" "default" {
#   default = true
# }

# data "aws_subnets" "default" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.lambda_name
  handler       = "function.handler"
  runtime       = "python3.12"

  create_package         = false
  local_existing_package = "./package.zip"
}

# module "lambda_alb" {
#   source = "terraform-aws-modules/alb/aws"

#   name    = "${var.lambda_name}-alb"
#   vpc_id  = data.aws_vpc.default.id
#   subnets = slice(data.aws_subnets.default.ids, 0, 2)

#   internal = true

#   security_group_ingress_rules = {
#     http = {
#       from_port   = 80
#       to_port     = 80
#       ip_protocol = "tcp"
#       cidr_ipv4   = "0.0.0.0/0"
#     }
#   }

#   listeners = {
#     http = {
#       port     = 80
#       protocol = "HTTP"

#       forward = {
#         target_group_key = "lamdba_target"
#       }
#     }
#   }

#   target_groups = {
#     lamdba_target = {
#       target_type              = "lambda"
#       target_id                = module.lambda_function.lambda_function_arn
#       attach_lambda_permission = true
#     }
#   }

#   enable_deletion_protection = false
# }
