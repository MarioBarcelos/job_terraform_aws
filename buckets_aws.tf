resource "aws_s3_bucket" "bucket_orig" {
  count = length(var.bucket_names)
  bucket = "${var.project_name}-${var.bucket_names[count.index]}-${var.environment}-${terraform.workspace}"
  force_destroy = true
    tags = {
      Bucket_Name = "${var.project_name}-${var.bucket_names[count.index]}-${var.environment}"
      environment = var.environment
      Cost_Center = "TEC"
      Project_Name = var.project_name
      }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket-encryption" {
  count = length(var.bucket_names)
  bucket = "${var.project_name}-${var.bucket_names[count.index]}-${var.environment}-${terraform.workspace}"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
      }
    }
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  count = length(var.bucket_names)
  bucket = "${var.project_name}-${var.bucket_names[count.index]}-${var.environment}-${terraform.workspace}"
  rule {
    object_ownership = "ObjectWriter"
    }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  count = length(var.bucket_names)
  bucket = "${var.project_name}-${var.bucket_names[count.index]}-${var.environment}-${terraform.workspace}"
  acl = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_public_access_block" "public_acces_block" {
  count = length(var.bucket_names)
  bucket = "${var.project_name}-${var.bucket_names[count.index]}-${var.environment}-${terraform.workspace}"

  block_public_acls = true
  block_public_policy = true 
  ignore_public_acls = true
  restrict_public_buckets = true
} 