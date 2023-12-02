import json

MAX_BUFFER_SIZE = 100

def lambda_handler(event, context):
    aggregate_data = []

    for record in event['Records']:
        # Extract the message body
        message_body = record['body']
        aggregate_data.append(json.loads(message_body))

        if len(aggregate_data) >= MAX_BUFFER_SIZE:
            write_to_efs(aggregate_data)
            aggregate_data = []

    # Write remaining data if buffer is not empty
    if aggregate_data:
        write_to_efs(aggregate_data)
    return {
        'statusCode': 200,
        'body': 'All snapshots processed successfully'
    }

def write_to_efs(data):
    # Function to write data to EFS
    with open('/mnt/efs/snapshots.jsonl', 'a') as file:
        for item in data:
            file.write(json.dumps(item) + '\n')
