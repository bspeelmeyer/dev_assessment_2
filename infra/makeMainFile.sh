#!/bin/bash
set +ex

## Hacky way to build main file
echo 'provider "aws" {' > main.tf
echo '  region = "us-east-1"' >> main.tf
echo '}' >> main.tf
echo '' >> main.tf
echo 'terraform {' >> main.tf
echo '  backend "s3" {' >> main.tf
bucket_id=$(cd ../bootstrap ; terraform output state_bucket_name)
echo "    bucket = $bucket_id" >> main.tf
echo '    key    = "terraform-remote-state-file/"' >> main.tf
echo '    region  = "us-east-1"' >> main.tf
table_name=$(cd ../bootstrap; terraform output dynamoDb_lock_table_name)
echo "    dynamodb_table = $table_name" >> main.tf
echo ' }' >> main.tf
echo '}' >> main.tf

## Hacky way to add ssh key to variables
echo 'variable "public_key" {' >> variables.tf
echo '  description = "The public key attached to the instance"' >> variables.tf
echo '  type        = string' >> variables.tf
ssh_public_key=$(cat ~/keys/ec2-key.pub)
echo "  default     =  \"$ssh_public_key\"" >> variables.tf
echo '}' >> variables.tf



