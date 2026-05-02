# Screenshot Guide

Add project screenshots to this folder using the filenames below so the main README stays consistent:

- `jenkins-success-build.png`
- `ecr-image-pushed.png`
- `lambda-cloudwatch-logs.png`

Recommended captures:

- Jenkins pipeline page or console output showing checkout, Docker build, ECR login, and image push
- Amazon ECR repository page showing the latest image tag
- CloudWatch logs for the Lambda function showing `SNS notification sent` and `Event stored in DynamoDB`
