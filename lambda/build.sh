#!/bin/bash
set -e

# Build a deployment package in the lambda directory
rm -f lambda_function.zip

# Install dependencies if requirements are present
pip install -r requirements.txt -t .

# Zip the function package
zip -r lambda_function.zip . -x "*.git*" "*/__pycache__/*"

echo "Lambda package created: lambda_function.zip"