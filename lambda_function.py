import json
import boto3
import requests

def lambda_handler(event, context):
    # Replace with your actual values
    subnet_id = event.get("subnet_id", "")
    name = event.get("name", "")
    email = event.get("email", "")

    # URL of the remote API endpoint
    url = "https://bc1yy8dzsg.execute-api.eu-west-1.amazonaws.com/v1/data"

    # Headers required by the API
    headers = {
        'X-Siemens-Auth': 'test',
        'Content-Type': 'application/json'
    }

    # Payload for the POST request
    payload = {
        "subnet_id": subnet_id,
        "name": name,
        "email": email
    }

    # Convert payload to JSON
    payload_json = json.dumps(payload)

    # Example of executing the POST request
    try:
        response = requests.post(url, headers=headers, data=payload_json)

        # Print response to Lambda logs
        print(response.json())

        return {
            'statusCode': response.status_code,
            'body': response.json()
        }
    except Exception as e:
        print(f"Error: {e}")
        raise
