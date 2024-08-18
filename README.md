# dynamic-tf-deploy

This project uses AWS s3 backend. It needs an encrypted S3 bucket to store state files and a DynamoDB table for state locking and consistency checking.

## Startup
### Before anything else
- Create a S3 bucket to store remote state files.
- Encrypt state files with KMS.
- Create a DynamoDB table for state locking.

## After creating the remote backend
On first run (if the backend hasn't yet been created). Set your AWS_ACCESS_KEY_ID=xxx & AWS_SECRET_ACCESS_KEY=xxx environment variables locally.

### Before any deployments
All the TF resources created will have a suffix with the enviroment abbreviation name that MUST be defined as an environment variable before the `terraform plan` and `terraform apply`, create and environment variable with the name TF_VAR_infra_env, ex: `export TF_VAR_infra_env=dev`
1. Check the `terraform.tfvars` file 

### Starting configurations
1. Navigate to the infrastructure directory.
2. Navigate to the main.tf inside the infrastructure folder and insert the values in `(terraform{backend{}})`.
3. Use `terraform init` to initialize the working directory- this will attempt to initialize the backend.

Terraform has been successfully initialized and the backend state is ready to be store in s3! You can now run plan to see the full infra planned.

### Next steps
2. Still inside the infrastructure directory use `terraform plan` to preview the changes or additions to the infrastructure.
3. Then use `terraform apply` to deploy the resources according to the objects inside the `terraform.tfvars` file.

## The Infra
- Create a VPC and public and private subnets
- Create an internet gateway and route table to create the private and public subnets
- Create security group for public and private traffic
- Create ECR repos for your docker images deployments
- Create ECS Clusters to deploy the ECR images. (Optional)
- Create EKS Clusters to deploy the Node groups and its k8s files.(Optional)

### Output of resources built and config
The current AWS resources built :

Changes to Outputs:
  + backend_table_name                 = (known after apply)
  + backend_bucket_name                = (known after apply)
  + backend_bucket_arn                 = (known after apply)

  + private_security_group             = (known after apply)
  + private_subnets                    = (known after apply)
  + public_security_group              = (known after apply)
  + public_subnets                     = (known after apply)
  + public_security_group_api          = (known after apply)

  + logs_endpoint                      = (known after apply)
  + cloudfront_bucket_name             = (known after apply)
  + cloudfront_domain_name             = (known after apply)

  + ecs_service_name                   = (known after apply)
  + ecs_name                           = (known after apply)
  + ecs_lb_arn                         = (known after apply)

  + alb_dns                            = (known after apply)