#!/bin/bash

# Build and run the Flask app locally
cd ../app
docker build -t devops-app .
docker run -p 5000:5000 devops-app