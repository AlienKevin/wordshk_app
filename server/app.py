import boto3
import json
from flask import Flask, request, abort

app = Flask(__name__)

sqs_client = boto3.client('sqs')
with open('sqs_url.txt', 'r') as file:
    sqs_url = file.read().strip()

with open('api_key.txt', 'r') as file:
    API_KEY = file.read().strip()

@app.before_request
def before_request():
    api_key = request.headers.get('X-API-KEY')
    if api_key != API_KEY:
        abort(401)  # Unauthorized access

@app.route('/upload/snapshot', methods=['POST'])
def upload():
    try:
        content = request.json
        response = sqs_client.send_message(QueueUrl=sqs_url, MessageBody=json.dumps(content))
        # Check if MessageId is in the response (indicative of success)
        if 'MessageId' in response:
            return '', 200  # OK
        else:
            # If no MessageId, something went wrong with the send
            return '', 500  # Internal Server Error
    except Exception as e:
        app.logger.error(f"Error sending message to SQS: {str(e)}")
        return None, 500

if __name__ == '__main__':
    app.run(debug=True)
