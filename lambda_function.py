import json
import boto3
import http.client

def lambda_handler(event, context):
    # Replace with your actual values
    subnet_id = 'subnet-0009622cf3792440a'
    name = 'Aryan Vijayvargiya'
    email = 'aryanvijayvargiya16@gmail.com'

    # URL of the remote API endpoint
    url = "https://bc1yy8dzsg.execute-api.eu-west-1.amazonaws.com/v1/data"
    conn = http.client.HTTPSConnection(url)

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
        conn.request("POST", url, json_data, headers)
        response = conn.getresponse()
        response_data = response.read().decode('utf-8')
        # Print response to Lambda logs
        print(response_data)

        return {
            'statusCode': response.status_code,
            'body': response.json()
        }
        conn.close()
    except Exception as e:
        print(f"Error: {e}")
        raise
