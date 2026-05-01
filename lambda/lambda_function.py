import json
import boto3
import os
import logging
import uuid
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        logger.info("Received event: %s", json.dumps(event))

        # Extract details from EventBridge event
        detail = event.get('detail', {})
        repo_name = detail.get('repository-name')
        image_tag = detail.get('image-tag')

        if not repo_name or not image_tag:
            raise ValueError("Missing repository-name or image-tag in event")

        # Send SNS notification
        sns = boto3.client('sns')
        sns_topic_arn = os.environ['SNS_TOPIC_ARN']
        message = f"New image pushed: {repo_name}:{image_tag}"
        sns.publish(
            TopicArn=sns_topic_arn,
            Subject="ECR Image Push Notification",
            Message=message
        )
        logger.info("SNS notification sent")

        # Store in DynamoDB
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

        event_id = str(uuid.uuid4())

        table.put_item(
            Item={
                'id': event_id,
                'repository': repo_name,
                'tag': image_tag,
                'timestamp': datetime.now().isoformat(),
                'event': json.dumps(event)
            }
        )
        logger.info("Event stored in DynamoDB")

        return {
            'statusCode': 200,
            'body': json.dumps('Event processed successfully')
        }

    except Exception as e:
        logger.error("Error processing event: %s", str(e))
        raise