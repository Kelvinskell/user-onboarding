resource "aws_dynamodb_table" "premium_users" {
  name = "PremiumUsers"
  hash_key = "username"  # Username will be the hash key for efficient lookups
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "username"
    type = "S"  # String data type for usernames
  }
}