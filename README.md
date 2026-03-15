# Unleash Live Assessment

This repository provisions a multi-region AWS deployment with shared authentication in `us-east-1`, then deploys an identical compute and data stack into `us-east-1` and `eu-west-1`.

## Repository Layout

- `infrastructure/modules/cognito`: Centralized Cognito User Pool, User Pool Client, and test user in `us-east-1`.
- `infrastructure/modules/compute_data`: Reusable regional orchestrator module for compute and data.
- `infrastructure/modules/network`: Cost-optimized VPC with public subnets and an Internet Gateway (no NAT Gateway).
- `infrastructure/modules/ecs`: ECS cluster, task definition, task roles, and task security group.
- `infrastructure/modules/lambda`: Single-function Lambda module (instantiated once for `greeter`, once for `dispatcher`).
- `infrastructure/modules/api_gateway`: HTTP API, Cognito JWT authorizer, route integrations, and Lambda invoke permissions.
- `infrastructure/env/prod`: Root Terraform configuration that creates Cognito in `us-east-1` and calls the regional module twice using aliased AWS providers.
- `infrastructure/scripts`: Lambda source files that Terraform packages with the `archive` provider.
- `tests`: Async Python validation script for Cognito authentication and cross-region endpoint testing.
- `.github/workflows/deploy.yml`: CI pipeline for formatting, validation, security scanning, and planning.

## AWS Credentials

Configure credentials locally before running Terraform:

```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..." # if you use temporary credentials
export AWS_REGION="us-east-1"
```

If you prefer profiles:

```bash
export AWS_PROFILE="your-profile"
export AWS_REGION="us-east-1"
```

The CI workflow expects GitHub Actions OIDC or a trusted role ARN in `AWS_ROLE_TO_ASSUME`.

## Terraform Variables

Copy `infrastructure/env/prod/terraform.tfvars.example` to `infrastructure/env/prod/terraform.tfvars` and set:

```hcl
candidate_email    = "your-email@example.com"
github_repo_url    = "https://github.com/<your-user>/aws-assessment"
test_user_password = "A-Strong-Password!123"
```

`verification_sns_topic_arn` already defaults to the provided external topic ARN and should not be changed unless the assessment input changes.

## Manual Terraform Apply

```bash
cd infrastructure/env/prod
terraform init
terraform plan
terraform apply
```

After apply, capture:

- `cognito_user_pool_id`
- `cognito_user_pool_client_id`
- `regional_api_endpoints`

## Run the Python Test Script

Install the test dependencies:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r tests/requirements.txt
```

Run the test:

```bash
python tests/test_endpoints.py \
  --user-pool-client-id "<cognito-client-id>" \
  --user-pool-id "<cognito-user-pool-id>" \
  --username "<candidate-email>" \
  --password "<test-user-password>" \
  --api-us-east-1 "<https://api-id.execute-api.us-east-1.amazonaws.com>" \
  --api-eu-west-1 "<https://api-id.execute-api.eu-west-1.amazonaws.com>"
```

The script authenticates with Cognito in `us-east-1`, then concurrently calls `GET /greet` and `POST /dispatch` in both regions, prints responses, asserts that each region matches the requested endpoint, and prints latency for comparison. If Cognito returns an initial `NEW_PASSWORD_REQUIRED` challenge, passing `--user-pool-id` allows the script to set a permanent password and continue automatically.

## Multi-Region Provider Structure

The root config defines:

- A default `aws` provider for `us-east-1`
- An aliased `aws.eu_west_1` provider for `eu-west-1`

The reusable module is instantiated twice using the standard Terraform pattern:

- `module.compute_data_us_east_1` uses `providers = { aws = aws }`
- `module.compute_data_eu_west_1` uses `providers = { aws = aws.eu_west_1 }`

Both regional APIs use a JWT authorizer that validates against the same Cognito User Pool issuer and client audience from `us-east-1`, so `eu-west-1` still authenticates against the centrally managed Cognito pool.

## Teardown

After successful verification SNS messages are sent, destroy infrastructure immediately to avoid ongoing charges:

```bash
cd infrastructure/env/prod
terraform destroy
```
