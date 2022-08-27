####################################################
# S3 Bucket tfstate packer network
####################################################

resource "aws_s3_bucket" "packer_manifest" {
  bucket = "infrati-packer-manifest"
  force_destroy = true

  tags = {
    Name        = "infrati-packer-manifest"
    Environment = "Development"
  }
}

####################################################
# S3 Bucket ACL Packer Network
####################################################

resource "aws_s3_bucket_acl" "packer_manifest" {
  bucket = aws_s3_bucket.packer_manifest.id
  acl    = "private"
}

####################################################
# Define Bucket Encryption
####################################################

resource "aws_s3_bucket_server_side_encryption_configuration" "packer_manifest" {
  bucket = aws_s3_bucket.packer_manifest.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

####################################################
# Enable S3 Bucket Versioning
####################################################

resource "aws_s3_bucket_versioning" "packer_manifest" {
  bucket = aws_s3_bucket.packer_manifest.id
  versioning_configuration {
    status = "Enabled"
  }
}

####################################################
# Copy packer_manifest.json
####################################################

locals {
  object_source = "../terraform-packer-build-aws/packer_manifest.json"
}

resource "aws_s3_object" "cp_packer_manifest" {
  depends_on = [
    aws_s3_bucket.packer_manifest
  ]
  bucket      = "infrati-packer-manifest"
  key         = "packer_manifest/packer_manifest.json"
  source      =  local.object_source
  source_hash = filemd5(local.object_source)
  force_destroy = true
}