import os
import json

def lambda_handler(event, context):
    landing_bucket = os.environ['LANDING_BUCKET']
    print(f"Extracting data and sending to landing bucket: {landing_bucket}")
    
    # Mock extracting from source (e.g., S3 delta)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Extraction successful')
    }
