# AWS EC2 Instance Terraform Module
# Host - EC2 Instance that will be created in VPC Public Subnet
module "ec2_public" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  # insert the required variables here
  name          = "${local.name}-Host"
  ami           = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  key_name      = var.instance_keypair
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_sg.security_group_id]
  tags                   = local.common_tags
}