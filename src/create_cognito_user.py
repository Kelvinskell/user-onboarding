import json
import boto3
import os

client = boto3.client('cognito-idp')

def lambda_handler(event, context):
    body = event['user_data']
    
    email = body['email']
    username = body['username']
    password = body['password']
    user_pool_id = os.environ['USER_POOL_ID']
    
    try:
        response = client.admin_create_user(
            UserPoolId=user_pool_id,
            Username=email,  # Use email as the username
            UserAttributes=[
                {
                    'Name': 'email',
                    'Value': email
                },
                {
                    'Name': 'email_verified',
                    'Value': 'true'
                }
            ],
            MessageAction='SUPPRESS'  # Suppress the welcome email
        )
        
        client.admin_set_user_password(
            UserPoolId=user_pool_id,
            Username=email,  # Use email as the username
            Password=password,
            Permanent=True
        )
        
        output = {
            'message:' 'user created successfully.'
            'email': email,
            'username': username,
        }

        return {
            'statusCode': 200,
            'body': json.dumps(output)
        }

    except client.exceptions.UsernameExistsException:
        raise Exception({
            'statusCode': 400,
            'body': json.dumps({
                'message': 'Username already exists'
            })
        })
    except Exception as e:
        raise Exception({
            'statusCode': 400,
            'body': json.dumps({
                'message': str(e)
            })
        })