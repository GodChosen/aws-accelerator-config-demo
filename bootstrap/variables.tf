################################################################
## shared
################################################################
variable "project_name" {
  type        = string
  description = "Name of the project."
}

variable "bucket_name" {
  description = "Name of the bucket."
  type        = string
}

variable "dynamodb_name" {
  description = "Name of the Dynamo DB lock table."
  type        = string
}

variable "region" {
  description = "AWS Region"
  default     = ""
  type        = string
}

variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

variable "profile" {
  type        = string
  description = "AWS profile to deploy resources"
  default     = ""
}

################################################################################
## kms
################################################################################
variable "kms_name" {
  description = "Name to assign the KMS CMK"
  type        = string
  default     = ""
}

variable "kms_admin_iam_role_identifier_arns" {
  description = "IAM Role ARN to add to the KMS key for management."
  type        = list(string)
  default     = []
}
