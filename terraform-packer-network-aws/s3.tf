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
