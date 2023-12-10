import boto3
import json

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('wordshk-dynamo')

    with table.batch_writer() as batch:
        for record in event['Records']:
            # Extract the message body and convert it to a dictionary
            item = json.loads(record['body'])
            # Ensure item contains 'UserId' and 'Timestamp' as keys
            batch.put_item(Item=item)
    return {
        'statusCode': 200,
        'body': 'All snapshots processed successfully'
    }
