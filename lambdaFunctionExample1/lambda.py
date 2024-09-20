# Import necessary libraries
import json
import boto3
import csv
from botocore.exceptions import ClientError

# Define the Lambda handler function
def lambda_handler(event, context):
    print("Received event:", json.dumps(event))

    # Initialize boto3 resource for S3
    s3 = boto3.resource('s3')
    
    # Initialize boto3 resource for DynamoDB
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1' )
    
    # Specify your DynamoDB table name
    table_name = 'gibson-db'
    table = dynamodb.Table(table_name)

    # Check if 'Records' key exists in the event
    if 'Records' not in event:
        print("No 'Records' key in event")
        # Handle the case where 'Records' is not present, if necessary
        return {
            'statusCode': 400,
            'body': json.dumps("Event does not contain 'Records'")
        }
    
    # Process each record in the event
    for record in event['Records']:
        # Check for 's3:ObjectCreated:*' event indicating a new file has been uploaded
        if record['eventName'].startswith('ObjectCreated'):
            bucket_name = record['s3']['bucket']['name']
            object_key = record['s3']['object']['key']
            
            try:
                # Grab the S3 object
                obj = s3.Object(bucket_name, object_key)
                data = obj.get()['Body'].read().decode("utf-8").splitlines()
                lines = csv.reader(data)
                
                # Skip the header
                headers = next(lines)
                
                # Process each row in the CSV
                for row in lines:
                    item = {headers[i]: row[i] for i in range(len(headers))}
                    
                    # Insert item into DynamoDB table
                    table.put_item(Item=item)
                    
            except ClientError as e:
                print(e.response['Error']['Message'])
            except Exception as e:
                print(str(e))
    
    return {
        'statusCode': 200,
        'body': json.dumps('CSV processing completed successfully')
    }
