# Terraform configuration

provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

module "ec2_instances_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"

  name           = "MiQ-ec2-public"
  instance_count = 1

  ami                    = "ami-04d5cc9b88f9d1d39"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Public = "Yes"
  }
}

module "ec2_instances_private" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"

  name           = "MiQ-ec2-private"
  instance_count = 1
  key_name               = "ansible"

  ami                    = "ami-04d5cc9b88f9d1d39"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.private_subnets[0]
  user_data              = "sudo yum update -y && sudo yum install -y curl policycoreutils openssh-server vim telnet git yum-utils && sudo yum install docker -y && sudo systemctl start docker && sudo systemctl enable docker && "
		              
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Public = "No"
  }
}

module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"
  
  name = "MiQ-nlb"

  load_balancer_type = "network"

  vpc_id  = module.vpc.default_vpc_id
  subnets = [module.vpc.public_subnets[0], module.vpc.private_subnets[0] ]
  
  access_logs = {
    bucket = "my-nlb-logs"
  }

  target_groups = [
    {
      name_prefix      = "MiQ-"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "ip"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "dev"
  }
}




