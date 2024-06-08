import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('PremiumUsers')

def lambda_handler(event, context):
    user_data = event['user_data']
    username = user_data['username']

    item = {
  "username": username
    }

    try: 
        table.put_item(Item=item)
        return {
            'statusCode': 200,
            'message': 'Premium user preferences uccessfully stored in table.'
        }
    
    except Exception as e:
        raise Exception(e)


