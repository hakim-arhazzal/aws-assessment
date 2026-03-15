import json
import os

import boto3


ecs = boto3.client("ecs")


def lambda_handler(event, context):
    region = os.environ["AWS_REGION_NAME"]

    response = ecs.run_task(
        cluster=os.environ["ECS_CLUSTER_ARN"],
        taskDefinition=os.environ["TASK_DEFINITION_ARN"],
        launchType="FARGATE",
        count=1,
        networkConfiguration={
            "awsvpcConfiguration": {
                "subnets": os.environ["SUBNET_IDS"].split(","),
                "securityGroups": [os.environ["SECURITY_GROUP_ID"]],
                "assignPublicIp": "ENABLED",
            }
        },
    )

    failures = response.get("failures", [])
    if failures:
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(
                {
                    "message": "Failed to start Fargate task.",
                    "region": region,
                    "failures": failures,
                }
            ),
        }

    tasks = response.get("tasks", [])
    task_arn = tasks[0]["taskArn"] if tasks else None

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(
            {
                "message": "Fargate task started.",
                "region": region,
                "taskArn": task_arn,
            }
        ),
    }

