
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block        = "10.0.0.0/16"
  vpc_name              = "Terraform_VPC"
  igw_name              = "terraform_IGW"
  nat_gateway_name      = "terraform_NAT"
  public_rt_name        = "terraform_PublicRouteTable"
  private_rt_name       = "terraform_PrivateRouteTable"

  public_subnet_az1      = "10.0.1.0/24"
  public_subnet_az2      = "10.0.2.0/24"
  private_web_subnet_az1 = "10.0.3.0/24"
  private_web_subnet_az2 = "10.0.4.0/24"
  private_db_subnet_az1  = "10.0.5.0/24"
  private_db_subnet_az2  = "10.0.6.0/24"

  az1 = "us-east-1a"
  az2 = "us-east-1b"
}

module "security" {
  source           = "./modules/security"
  vpc_id           = module.vpc.vpc_id
  my_ip            = "197.210.53.31/32"
  enable_rds_role  = true
}


