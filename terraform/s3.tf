# Create a bucket
resource "aws_s3_bucket" "unigranrio" {
  bucket = var.s3_name[terraform.workspace]
  acl    = "private"
  force_destroy = true

  website {
    index_document = var.s3_index_filename
    error_document = var.s3_error_filename

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }

  tags = merge(var.tags,
   {
    Name	= var.s3_name[terraform.workspace]
    environment	= terraform.workspace
   },
  )
}

# Create a bucket policy
resource "aws_s3_bucket_policy" "unigranrio" {
  bucket = aws_s3_bucket.unigranrio.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.s3_name[terraform.workspace]}/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "unigranrio" {
  bucket = aws_s3_bucket.unigranrio.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true

  depends_on = [aws_s3_bucket.unigranrio, aws_s3_bucket_policy.unigranrio]

}

resource "null_resource" "remove_and_upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync ../site/ s3://${aws_s3_bucket.unigranrio.id}"
  }
}
