# Automated Docker Image Deployment to Amazon ECR with Jenkins & Lambda using Terraform

## Project Overview

This project implements a complete CI/CD pipeline that automates the deployment of Docker images to Amazon ECR, with event-driven notifications and logging using AWS Lambda, EventBridge, SNS, and DynamoDB.

## Architecture

```
GitHub Push → Jenkins → Docker Build → ECR Push → EventBridge → Lambda → SNS Notification & DynamoDB Log
```

### Components:
- **Jenkins**: CI/CD server that builds and pushes Docker images
- **Docker**: Containerizes the Flask application
- **Amazon ECR**: Stores Docker images with scanning and lifecycle policies
- **EventBridge**: Triggers on ECR image push events
- **AWS Lambda**: Processes events, sends notifications, and logs to DynamoDB
- **SNS**: Sends email notifications
- **DynamoDB**: Stores event logs
- **Terraform**: Infrastructure as Code for AWS resources

## Tech Stack

- **Infrastructure**: Terraform, AWS (ECR, Lambda, EventBridge, SNS, DynamoDB, IAM)
- **CI/CD**: Jenkins, Docker
- **Application**: Python Flask
- **Scripting**: Bash

## Prerequisites

- AWS Account with appropriate permissions
- Jenkins server with Docker and AWS CLI installed
- GitHub repository
- Terraform installed locally
- AWS CLI configured with credentials

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd devops-ecr-pipeline
```

### 2. Configure AWS Credentials

Ensure AWS CLI is configured:

```bash
aws configure
```

### 3. Update Variables

Edit `terraform/variables.tf` and update:
- `email_subscription`: Your email for SNS notifications

### 4. Build Lambda Package

```bash
cd lambda
chmod +x build.sh
./build.sh
cd ..
```

### 5. Deploy Infrastructure

```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

Or manually:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 5. Test Application Locally

Before deploying to AWS, test the Docker application locally:

```bash
# Build and run the app
chmod +x scripts/run_app.sh
./scripts/run_app.sh

# Visit http://localhost:5000 to verify "CI/CD Pipeline Working!"
```

### 6. Configure Jenkins

1. Install required plugins: Docker, AWS Credentials, Git
2. Create a new pipeline job
3. Configure SCM to point to your GitHub repo
4. Set pipeline script from SCM, path: `jenkins/Jenkinsfile`
5. Configure AWS credentials in Jenkins (use IAM user with ECR permissions)
6. Ensure Jenkins agent has Docker installed and running

### 7. Verify SNS Subscription

Check your email and confirm the SNS subscription to receive notifications.

## Pipeline Flow

1. **Code Push**: Developer pushes code to GitHub
2. **Jenkins Trigger**: Jenkins detects changes and starts pipeline
3. **Docker Build**: Builds Docker image from `app/` directory
4. **Image Tagging**: Tags image with Git commit SHA
5. **ECR Authentication**: Logs into ECR using AWS credentials
6. **Image Push**: Pushes tagged image to ECR
7. **EventBridge Trigger**: Detects successful push and triggers Lambda
8. **Lambda Processing**:
   - Extracts repository name and tag from event
   - Sends SNS notification email
   - Logs event details to DynamoDB
9. **Cleanup**: Removes local Docker images

## Testing the Pipeline

1. Make a change to the code (e.g., update `app/app.py`)
2. Commit and push to GitHub
3. Jenkins should automatically trigger the pipeline
4. Monitor Jenkins console for build progress
5. Verify in AWS Console:
   - ECR: New image with commit SHA tag
   - DynamoDB: New entry in `ecr-events` table
   - Email: SNS notification received

## File Structure

```
devops-ecr-pipeline/
├── terraform/
│   ├── main.tf          # AWS resources definition
│   ├── variables.tf     # Configuration variables
│   ├── outputs.tf       # Terraform outputs
│   └── provider.tf      # AWS provider configuration
├── app/
│   ├── Dockerfile       # Docker image definition
│   ├── requirements.txt # Python dependencies
│   └── app.py           # Flask application
├── lambda/
│   ├── lambda_function.py # Lambda handler code
│   ├── requirements.txt   # Lambda dependencies
│   └── build.sh           # Build script for Lambda package
├── jenkins/
│   └── Jenkinsfile       # Jenkins pipeline definition
├── scripts/
│   ├── deploy.sh         # Terraform deployment script
│   └── ecr_login.sh      # ECR login script
└── README.md
```

## Security Considerations

- IAM roles use least privilege principles
- No hardcoded credentials in code
- Sensitive files excluded via .gitignore
- ECR image scanning enabled
- Lifecycle policies prevent unlimited image accumulation

## Troubleshooting

### Jenkins Build Fails
- Ensure Docker is installed and running on Jenkins agent
- Verify AWS credentials are configured in Jenkins
- Check ECR repository permissions

### Lambda Not Triggering
- Verify EventBridge rule is active
- Check CloudWatch logs for Lambda errors
- Ensure Lambda has necessary permissions

### SNS Email Not Received
- Confirm email subscription is confirmed
- Check SNS topic permissions
- Verify Lambda environment variables

### Terraform Apply Fails
- Ensure AWS credentials have sufficient permissions
- Check region configuration
- Verify variable values

### ECR Login Issues in Jenkins
- Ensure AWS CLI is installed on Jenkins agent
- Verify Jenkins has AWS credentials configured
- Check that Docker daemon is running

### Lambda Not Triggering
- Verify EventBridge rule is enabled
- Check CloudWatch logs for Lambda errors
- Ensure Lambda has EventBridge invoke permission

### Docker Build Fails
- Ensure Docker is installed and running
- Check Dockerfile syntax
- Verify app/requirements.txt dependencies

## Cleanup

To destroy all resources:

```bash
cd terraform
terraform destroy
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes and test
4. Submit a pull request

## License

This project is licensed under the MIT License.
>>>>>>> 5640132 (Initialize automated ECR deployment pipeline project)
