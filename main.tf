module "s3" {
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


module "lambda" {
  source          = "./modules/lambda"
  function_name   = var.ingest_lambda_name
  lambda_zip      = data.archive_file.lambda_zip_ingest.output_path
  runtime         = var.lambda_runtime
  role_arn        = module.lambda_iam_role.iam_role_arn
  environment_vars = {
    DB_SECRET_NAME = var.db_secret_name
    RAW_BUCKET     = var.bucket_name
  }
  vpc_config = {
    subnet_ids         = module.vpc.private_subnets
    security_group_ids = [module.rds_sg.rds_security_group_aurora_id]
  }
  tags = var.tags

  depends_on = [
    module.s3,
    module.vpc,
    module.iam,
    #module.db_secret
  ]
}

