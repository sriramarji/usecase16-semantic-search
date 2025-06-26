module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  tags        = var.tags
}


module "vpc" {
  source = "./modules/vpc"
  name           = var.name
  vpc_cidr_block = var.vpc_cidr_block

  depends_on = [
    module.s3_bucket
  ]
}

module "iam" {
  source      = "./modules/iam"
  bucket_name = module.s3_bucket.bucket_name
}
