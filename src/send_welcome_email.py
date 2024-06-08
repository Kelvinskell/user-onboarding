import boto3
import json
import os

sns_client = boto3.client('sns')
TOPIC_ARN = os.environ['TOPIC_ARN']

def lambda_handler(event, context):
    if type(event) == list:
        body = event[1].get('body')
    else:
        body = event.get('body')
    if body:
          # Parse the JSON string inside the body field
          body = json.loads(body)

          # Extract the username from the parsed JSON data
          user = body.get('username')
          message = f"Hello {user}, welcome to our ride-hailing service!"
          response = sns_client.publish(
               TopicArn=TOPIC_ARN,
               Message=message,
               Subject='Welcome to Our Ride-Hailing Service'
               )
          return {
               'statusCode': 200,
               'body': json.dumps({'message': 'Welcome email sent successfully'})
               }