import os
import json
from datetime import datetime

def lambda_handler(event, context):
    landing_bucket = os.environ['LANDING_BUCKET']
    staging_bucket = os.environ['STAGING_BUCKET']
    
    print(f"Reading from {landing_bucket}, writing to {staging_bucket}")
    
    # Read from landing, append added_date, write to staging in CSV
    current_date = datetime.utcnow().strftime('%Y-%m-%d')
    
    return {
        'statusCode': 200,
        'body': json.dumps(f'Transformation successful. Added date: {current_date}')
    }
