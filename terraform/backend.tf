# Remote state assumes DynamoDB and the S3 bucket
# are already deployed, so if this is the first time 
# running Terraform, comment out the following resource
# or rename the file to something other than *.tf 
# (*.tf.inactive, for example) - then after you apply
# the first time, uncomment/rename and re-apply

terraform {
  backend "s3" {
    bucket         = "woodybox-terraform-state-backend"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform_state"
    encrypt        = true
  }
}
