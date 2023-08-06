# Demo Terraform AWS Infrastructure: Mono Repo: Terraform State Backend Bootstrap  

## Overview

This directory contains resources used for managing the Terraform Backend State.  

## Usage
1. Initialize the backend:
  ```shell
  terraform init -backend-config config.dev.hcl
  ```
2. Create a `dev` workspace
  ```shell
  terraform workspace new dev
  ```
3. Plan Terraform
  ```shell
  terraform plan -var-file dev.tfvars
  ```
4. Apply Terraform
  ```shell
  terraform apply -var-file dev.tfvars
  ```

When Terraform has finished applying the bootstrapped resources, we will need to move the local state the new bucket.

:exclamation: This section assumes you have already set your `AWS_PROFILE` environment variable to the proper profile to apply the state to. :exclamation:  

Once you have the tfstate file locally, you will move it to S3:  
1. Open `main.tf` and uncomment `backend "s3" {}`:
  ```
  terraform {
   required_version = "~> 1.0"

   required_providers {
     aws = {
       version = "~> 3.0"
       source  = "hashicorp/aws"
     }
   }

   backend "s3" {}
  }
  ```

2. Initialize Terraform and migrate the state to s3.
  ```shell
  terraform init -backend-config config.dev.hcl -migrate-state
  ```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.76.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bootstrap"></a> [bootstrap](#module\_bootstrap) | git::https://github.com/sourcefuse/terraform-module-aws-bootstrap | 1.0.9 |
| <a name="module_kms"></a> [kms](#module\_kms) | git::https://github.com/cloudposse/terraform-aws-kms-key | 0.12.1 |
| <a name="module_tags"></a> [tags](#module\_tags) | git::https://github.com/sourcefuse/terraform-aws-refarch-tags | 1.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [random_integer.default](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/integer) | resource |
| [aws_caller_identity.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the bucket. | `string` | n/a | yes |
| <a name="input_dynamodb_name"></a> [dynamodb\_name](#input\_dynamodb\_name) | Name of the Dynamo DB lock table. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_kms_admin_iam_role_identifier_arns"></a> [kms\_admin\_iam\_role\_identifier\_arns](#input\_kms\_admin\_iam\_role\_identifier\_arns) | IAM Role ARN to add to the KMS key for management. | `list(string)` | `[]` | no |
| <a name="input_kms_name"></a> [kms\_name](#input\_kms\_name) | Name to assign the KMS CMK | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS profile to deploy resources | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_state_bucket_arn"></a> [state\_bucket\_arn](#output\_state\_bucket\_arn) | State bucket ARN |
| <a name="output_state_bucket_name"></a> [state\_bucket\_name](#output\_state\_bucket\_name) | State bucket name |
| <a name="output_state_lock_table_arn"></a> [state\_lock\_table\_arn](#output\_state\_lock\_table\_arn) | State lock table ARN |
| <a name="output_state_lock_table_name"></a> [state\_lock\_table\_name](#output\_state\_lock\_table\_name) | State lock table name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
