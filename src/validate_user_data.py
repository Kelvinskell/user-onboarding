import json

def lambda_handler(event, context):
    user_data = event.get('user_data', {})
    required_fields = ['username', 'email', 'password']
    
    for field in required_fields:
        if field not in user_data:
            raise Exception(json.dumps({'error': f'Missing required field: {field}'}))
    
    return {'message': 'User data is valid', 'user_data': user_data}
    