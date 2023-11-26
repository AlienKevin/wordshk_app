def lambda_handler(event, context):
    file_path = '/mnt/efs/snapshots.jsonl'  # Adjust as per your EFS mount and file path

    try:
        with open(file_path, 'r') as file:
            data = file.read()
            return {
                'statusCode': 200,
                'body': data
            }
    except FileNotFoundError:
        return {
            'statusCode': 404,
            'body': 'snapshots.jsonl not found'
        }