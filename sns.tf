resource "aws_sns_topic" "topic" {
  name = "UserOnboardingTopic"
}

resource "aws_sns_topic_subscription" "topic_sub" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.email_address
}
variable "email_address" {
    # Create a default email
    # default = example@gmail.com
}