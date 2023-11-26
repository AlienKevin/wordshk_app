import json
import os
from flask import Flask, request, jsonify, abort

app = Flask(__name__)

# Temporary buffer
message_buffer = []
MAX_BUFFER_SIZE = 10

# Set file paths based on environment variable
FLASK_ENV = os.environ.get('FLASK_ENV', 'production')
DEBUG_FILE_PATH = 'messages_debug.jsonl'
PROD_FILE_PATH = '/mnt/efs/messages.jsonl'
FILE_PATH = DEBUG_FILE_PATH if FLASK_ENV == 'development' else PROD_FILE_PATH

with open('api_key.txt', 'r') as file:
    API_KEY = file.read().strip()

@app.before_request
def before_request():
    api_key = request.headers.get('X-API-KEY')
    if api_key != API_KEY:
        abort(401)  # Unauthorized access

@app.route('/upload/snapshot', methods=['POST'])
def upload():
    global message_buffer
    content = request.json

    # Append the message to the buffer
    message_buffer.append(content)

    # Check if buffer size exceeds the limit
    if len(message_buffer) >= MAX_BUFFER_SIZE:
        flush_to_file()

    return jsonify({"status": "success"})

def flush_to_file():
    global message_buffer
    # Open file and append messages
    with open(FILE_PATH, 'a') as file:
        for message in message_buffer:
            file.write(json.dumps(message) + '\n')

    # Clear the buffer
    message_buffer = []

if __name__ == '__main__':
    app.run(debug=True)
