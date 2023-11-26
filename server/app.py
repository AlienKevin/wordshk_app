import json
import os
import threading
from flask import Flask, request, jsonify, abort

app = Flask(__name__)

# Temporary buffer and lock
snapshot_buffer = []
buffer_lock = threading.Lock()

# Set file paths based on environment variable
FLASK_ENV = os.environ.get('FLASK_ENV', 'production')
DEBUG_FILE_PATH = 'snapshots.jsonl'
PROD_FILE_PATH = '/mnt/efs/snapshots.jsonl'
FILE_PATH = DEBUG_FILE_PATH if FLASK_ENV == 'development' else PROD_FILE_PATH
MAX_BUFFER_SIZE = 1 if FLASK_ENV == 'development' else 10

with open('api_key.txt', 'r') as file:
    API_KEY = file.read().strip()

@app.before_request
def before_request():
    api_key = request.headers.get('X-API-KEY')
    if api_key != API_KEY:
        abort(401)  # Unauthorized access

@app.route('/upload/snapshot', methods=['POST'])
def upload():
    content = request.json

    with buffer_lock:
        # Append the snapshot to the buffer
        snapshot_buffer.append(content)

        # Check if buffer size exceeds the limit and flush if needed
        if len(snapshot_buffer) >= MAX_BUFFER_SIZE:
            flush_to_file()

    return jsonify({"status": "success"})

def flush_to_file():
    global snapshot_buffer
    # Open file and append messages
    with open(FILE_PATH, 'a') as file:
        for snapshot in snapshot_buffer:
            file.write(json.dumps(snapshot) + '\n')

    # Clear the buffer
    snapshot_buffer = []

if __name__ == '__main__':
    app.run(debug=True)
