data "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  /* tags = {
    Name = var.bucket_name
  } */
}


resource "aws_s3_bucket_policy" "policy_attachment" {
  bucket = data.aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.bucket_policy.json

}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AllowSpecificAccount"
    principals {
      type        = "AWS"
      identifiers = ["593793035673"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      data.aws_s3_bucket.example.arn,
      "${data.aws_s3_bucket.example.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = data.aws_s3_bucket.example.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = data.aws_s3_bucket.example.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
    aws_s3_bucket_policy.policy_attachment
  ]

  bucket = data.aws_s3_bucket.example.id
  acl    = "public-read-write"
}

resource "aws_s3_object" "object" {
  bucket = data.aws_s3_bucket.example.id
  key    = "ganesh.jpeg"
  source = "${path.module}/ganesh.jpeg"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  content_type = "text/html"
  acl          = "public-read"
  etag         = filemd5("${path.module}/ganesh.jpeg")
}
