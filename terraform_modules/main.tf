
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

module "compute" {
  source = "./modules/compute"

  instance_type         = "t2.micro"
  app_sg_id             = module.security.app_sg_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  #target_group_arn      = module.lb.target_group_arn
  asg_min_size          = 1
  asg_max_size          = 4
  asg_desired_capacity  = 1
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  web_sg_id           = module.security.web_sg_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  vpc_id              = module.vpc.vpc_id
}

module "database" {
  source = "./modules/database"

  private_db_subnet_ids = module.vpc.private_db_subnet_ids
  db_sg_id              = module.security.db_sg_id
  db_name               = "terraform_db"
  db_username           = "admin"
  db_password           = "terraform_password"
}


