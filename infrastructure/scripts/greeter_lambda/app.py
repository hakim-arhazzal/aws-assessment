import json
import os
import time
import uuid

import boto3


dynamodb = boto3.client("dynamodb")


def lambda_handler(event, context):
    region = os.environ["AWS_REGION_NAME"]
    table_name = os.environ["DYNAMODB_TABLE"]
    topic_arn = os.environ["SNS_TOPIC_ARN"]
    topic_region = topic_arn.split(":")[3]
    sns = boto3.client("sns", region_name=topic_region)

    item = {
        "id": {"S": str(uuid.uuid4())},
        "timestamp": {"N": str(int(time.time() * 1000))},
        "region": {"S": region},
        "request_id": {"S": context.aws_request_id},
        "source": {"S": "Lambda"},
    }
    dynamodb.put_item(TableName=table_name, Item=item)

    message = {
        "email": os.environ["CANDIDATE_EMAIL"],
        "source": "Lambda",
        "region": region,
        "repo": os.environ["GITHUB_REPO_URL"],
    }
    sns.publish(
        TopicArn=topic_arn,
        Message=json.dumps(message),
    )

    body = {
        "message": "Greeting accepted.",
        "region": region,
    }
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }
