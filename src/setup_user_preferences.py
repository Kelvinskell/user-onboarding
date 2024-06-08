import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('UserPreferences')

def lambda_handler(event, context):
    user_data = event['user_data']
    
    preferences = {
        'username': user_data['username'],
        'preference1': 'default_value1',
        'preference2': 'default_value2'
    }
    
    table.put_item(Item=preferences)
    
    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'User preferences set successfully'})
    }