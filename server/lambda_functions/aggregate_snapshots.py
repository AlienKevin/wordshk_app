import boto3
import json

MAX_BUFFER_SIZE = 100

def lambda_handler(event, context):
    aggregate_data = []

    for record in event['Records']:
        # Extract the message body and convert it to a dictionary
        message_body = json.loads(record['body'])

        aggregate_data.append(message_body)

        if len(aggregate_data) >= MAX_BUFFER_SIZE:
            write_to_dynamodb(aggregate_data)
            aggregate_data = []

    # Write remaining data if buffer is not empty
    if aggregate_data:
        write_to_dynamodb(aggregate_data)
    return {
        'statusCode': 200,
        'body': 'All snapshots processed successfully'
    }

def write_to_dynamodb(data):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('wordshk')

    with table.batch_writer() as batch:
        for item in data:
            # Ensure item contains 'UserId' and 'Timestamp' as keys
            batch.put_item(Item=item)