import json
import boto3
import csv

def lambda_handler(event, context):

   try:
      region = 'us-east-1'
      # create your EC2 client here for your specified region
      ec2 = boto3.client('ec2', region_name=region)  # Create EC2 client
      dynamodb = boto3.resource('dynamodb', region_name=region)  # DynamoDB resource
      table = dynamodb.Table('gibson-ec2-table') 

      # Describe EC2 instances
      response = ec2.describe_instances()
      # collect and print data
      # Iterate over all reservations and instances
      for reservation in response['Reservations']:
        for instance in reservation['Instances']:
          # Example: Print instance ID and state
            print(f"Instance ID: {instance['InstanceId']} - State: {instance['State']['Name']} - Region: {region} ")
          # Put item in DynamoDB table
            table.put_item(
            Item={
                'InstanceId': instance['InstanceId'],  # Primary key
                'State': instance['State']['Name'],
                'Region': region,
                # Add other attributes here
                }
            )

    

   except Exception as e:
      print(str(e))

   return {
      'statusCode': 200,
      'body': json.dumps('It got to the end of the function')
    }
