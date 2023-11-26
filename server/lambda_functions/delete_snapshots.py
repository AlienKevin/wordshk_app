import os

def lambda_handler(event, context):
    file_path = '/mnt/efs/snapshots.jsonl'  # Adjust as per your EFS mount and file path

    try:
        os.remove(file_path)
        return {
            'statusCode': 200,
            'body': 'File deleted successfully'
        }
    except FileNotFoundError:
        return {
            'statusCode': 404,
            'body': 'File not found'
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': 'Error deleting file: ' + str(e)
        }