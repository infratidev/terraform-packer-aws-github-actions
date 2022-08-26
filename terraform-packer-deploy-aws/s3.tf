#Upload
locals {
  object_source = "../terraform-packer-build-aws/packer-manifest.json"
}

resource "aws_s3_object" "cp_packer_manifest" {
  bucket      = "infrati-tfstate-packer-terraform"
  key         = "packer_manifest/packer_manifest.json"
  source      =  local.object_source
  source_hash = filemd5(local.object_source)
  force_destroy = true
}