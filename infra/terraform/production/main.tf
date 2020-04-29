#=============
# Input Value
#=============
// AWS認証情報
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}

// VPC
variable "vpc_cidr_block" {}

// Security Group
variable "sg_inbound_cidr_block" {}
variable "sg_outbound_cidr_block" {}

// Subnet
variable "subnet_public_1a_cidr_block" {}
variable "subnet_public_1c_cidr_block" {}

// Internet Gateway
variable "igw_cidr_block" {}

// Route53
variable "r53_domain_name" {}
variable "r53_record_set_name" {}
variable "r53_record_type" {}

// EC2 Instance
variable "instance_number" {}
variable "instance_app_name" {}

// Key Pair
variable "key_name" {}
variable "public_key_path" {}

#============
# AWS認証情報
#============
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}

#=============
# VPC
#=============
module "vpc_module" {
  
  // モジュールのResourceを参照.
  source = "../modules/vpc"
  
  // モジュールに値を注入.
  region                      = var.region
  vpc_cidr_block              = var.vpc_cidr_block
  subnet_public_1a_cidr_block = var.subnet_public_1a_cidr_block
  subnet_public_1c_cidr_block = var.subnet_public_1c_cidr_block
  igw_cidr_block              = var.igw_cidr_block 
  instance_app_name           = var.instance_app_name
}

#================
# Security Gruop
#================
module "security_group_module" {
  
  // モジュールのResourceを参照.
  source = "../modules/security_group"

  // モジュールに値を注入.
  vpc_id                 = module.vpc_module.vpc_id
  sg_inbound_cidr_block  = var.sg_inbound_cidr_block
  sg_outbound_cidr_block = var.sg_outbound_cidr_block
  instance_app_name      = var.instance_app_name
}

#=============
# ALB
#=============
module "alb_module" {
  
  // モジュールのResourceを参照.
  source = "../modules/alb"

  // モジュールに値を注入.
  region                = var.region
  vpc_id                = module.vpc_module.vpc_id
  subnet_public_1a_id   = module.vpc_module.subnet_public_1a_id
  subnet_public_1c_id   = module.vpc_module.subnet_public_1c_id
  security_group_alb_id = module.security_group_module.security_group_alb_id
  instance_app_name     = var.instance_app_name
}

#=============
# Route53
#=============
module "route53_module" {

  // モジュールのResourceを参照.
  source = "../modules/route53"

  // モジュールに値を注入.
  r53_alb_dns_name    = module.alb_module.alb_dns_name
  r53_alb_zone_id     = module.alb_module.alb_zone_id
  r53_domain_name     = var.r53_domain_name
  r53_record_set_name = var.r53_record_set_name
  r53_record_type     = var.r53_record_type
}

#==============
# EC2 Instance
#==============
module "ec2_instance_module" {

  // モジュールのResourceを参照.
  source = "../modules/ec2_instance"

  // モジュールに値を注入.
  instance_number   = var.instance_number
  instance_app_name = var.instance_app_name
  key_name          = var.key_name
  public_key_path   = var.public_key_path
}