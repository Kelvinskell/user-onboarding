resource "aws_s3_bucket" "user_onboarding_bucket" {
  bucket = "user-onboarding-workflow-bucket-10000110101001"  # Ensure this bucket name is unique

}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.user_onboarding_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "user_onboarding_bucket" {
  bucket = aws_s3_bucket.user_onboarding_bucket.id
  block_public_acls = false
  block_public_policy = false
}