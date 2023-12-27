import boto3
import json
from botocore.exceptions import ClientError
from dynamodb_json import json_util as dynjson

# Initialize a DynamoDB client
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('wordshk-dynamo')

def download_table_as_json(table):
    all_items = []

    try:
        # Scan the table without projection expression to get all attributes
        response = table.scan()
    except ClientError as e:
        print("An error occurred:", e.response['Error']['Message'])
        return

    while True:
        items = response.get('Items', [])
        all_items.extend([dynjson.loads(item) for item in items])

        # Handle pagination
        if 'LastEvaluatedKey' not in response:
            break
        response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])

    # Save the data as a JSON file
    with open('dynamodb_data.json', 'w') as file:
        json.dump(all_items, file, indent=4)

if __name__ == "__main__":
    download_table_as_json(table)
