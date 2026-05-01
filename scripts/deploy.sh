#!/bin/bash
set -e

cd "$(dirname "$0")/../terraform"

terraform init
terraform validate
terraform apply -auto-approve