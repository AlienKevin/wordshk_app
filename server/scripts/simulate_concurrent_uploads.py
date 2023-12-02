import boto3
import concurrent.futures
import json
import requests
from concurrent.futures import ThreadPoolExecutor

with open('../api_key.txt', 'r') as file:
    API_KEY = file.read().strip()

url = "https://1cvycekk7e.execute-api.ap-east-1.amazonaws.com/dev/upload/snapshot"

headers = {
    'X-API-KEY': API_KEY,
    'Content-Type': 'application/json'
}

sqs_client = boto3.client('sqs')
with open('../sqs_url.txt', 'r') as file:
    sqs_url = file.read().strip()


def make_request(id: int):
    payload = json.dumps({
        "id": str(id),
        "date": "20231126"
    })
    try:
        # response = requests.request("POST", url, headers=headers, data=payload)
        response = sqs_client.send_message(QueueUrl=sqs_url, MessageBody=json.dumps(payload))
        return response
    except requests.RequestException as e:
        return e

# Make many concurrent requests
NUM_REQUESTS = 1000
num_errors = 0

with ThreadPoolExecutor(max_workers=1000) as executor:
    futures = [executor.submit(make_request, id) for id in range(NUM_REQUESTS)]

    for future in concurrent.futures.as_completed(futures):
        response = future.result()
        if 'MessageId' not in response:
            num_errors += 1
            print(f"Error: {response}")
    print(f"Total errors: {num_errors}")
