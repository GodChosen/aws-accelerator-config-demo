################################################################################
## Common
################################################################################

module "tags" {
  source = "git::https://github.com/sourcefuse/terraform-aws-refarch-tags?ref=1.1.0"

  environment = var.environment
  project     = var.project_name
}

resource "random_integer" "default" {
  min = 1
  max = 50000
}

################################################################################
## kms
################################################################################

resource "aws_iam_role_policy" "default" {
  name = "kms-admin-${var.environment}"
  role = aws_iam_role.default.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "default" {
  name = "kms-admin-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:${data.aws_partition.default.partition}:iam::${data.aws_caller_identity.default.account_id}:root"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

## kms
data "aws_iam_policy_document" "kms" {
  version = "2012-10-17"

  ## allow ec2 access to the key
  statement {
    effect = "Allow"

    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]

    resources = ["*"]

    principals {
      type = "Service"
      identifiers = [
        "s3.amazonaws.com"
      ]
    }
  }

  statement {
    effect = "Allow"

    // * is required to avoid default error from the API - MalformedPolicyDocumentException: The new key policy will not allow you to update the key policy in the future.
    actions = ["kms:*"]

    // * is required to avoid default error from the API - MalformedPolicyDocumentException: The new key policy will not allow you to update the key policy in the future.
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.default.partition}:iam::${data.aws_caller_identity.default.account_id}:root"]
    }
  }

  ## allow administration of the key
  dynamic "statement" {
    for_each = sort(toset(concat([aws_iam_role.default.arn], var.kms_admin_iam_role_identifier_arns)))

    content {
      effect = "Allow"

      // * is required to avoid default error from the API - MalformedPolicyDocumentException: The new key policy will not allow you to update the key policy in the future.
      actions = ["kms:*"]

      // * is required to avoid default error from the API - MalformedPolicyDocumentException: The new key policy will not allow you to update the key policy in the future.
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = [statement.value]
      }
    }
  }
}

## Create kms key for backend Dynamodb
module "kms" {
  source = "git::https://github.com/cloudposse/terraform-aws-kms-key?ref=0.12.1"

  name                    = var.bucket_name
  description             = "KMS key for DynamoDB encryption."
  label_key_case          = "lower"
  multi_region            = false
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/${var.namespace}/${var.environment}/${var.kms_name}-${random_integer.default.result}"
  policy                  = data.aws_iam_policy_document.kms.json

  tags = module.tags.tags
}

#########################################################################
## Backend s3 bucket & Dynamodb table using Bootstrap
#########################################################################

module "bootstrap" {
  source = "git::https://github.com/sourcefuse/terraform-module-aws-bootstrap?ref=1.0.9"

  bucket_name              = "${var.bucket_name}-${random_integer.default.result}"
  dynamodb_name            = var.dynamodb_name
  dynamo_kms_master_key_id = module.kms.key_arn

  tags = module.tags.tags

}
