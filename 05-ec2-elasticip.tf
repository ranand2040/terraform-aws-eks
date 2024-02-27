# Create Elastic IP for Host
# Resource - depends_on Meta-Argument
resource "aws_eip" "eip" {
  depends_on = [module.ec2_public, module.vpc]
  instance   = module.ec2_public.id
  #vpc        = true
  domain     = "vpc"
  tags       = local.common_tags
}

