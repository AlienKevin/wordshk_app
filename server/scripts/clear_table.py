import boto3
from botocore.exceptions import ClientError

# Initialize a DynamoDB client
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('wordshk-dynamo')

def clear_table(table, partition_key_name, sort_key_name):
    # Using expression attribute names to handle reserved keywords
    expression_attribute_names = {
        "#pk": partition_key_name,
        "#sk": sort_key_name
    }

    try:
        response = table.scan(
            ProjectionExpression="#pk, #sk",
            ExpressionAttributeNames=expression_attribute_names
        )
    except ClientError as e:
        print("An error occurred:", e.response['Error']['Message'])
        return

    with table.batch_writer() as batch:
        while True:
            items = response.get('Items', [])
            if not items:
                break

            for item in items:
                batch.delete_item(Key={
                    partition_key_name: item[partition_key_name],
                    sort_key_name: item[sort_key_name]
                })

            # Handle pagination
            if 'LastEvaluatedKey' not in response:
                break
            response = table.scan(
                ProjectionExpression="#pk, #sk",
                ExpressionAttributeNames=expression_attribute_names,
                ExclusiveStartKey=response['LastEvaluatedKey']
            )

if __name__ == "__main__":
    PARTITION_KEY_NAME = 'UserId'
    SORT_KEY_NAME = 'Timestamp'
    clear_table(table, PARTITION_KEY_NAME, SORT_KEY_NAME)
