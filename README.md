## Infrastructure of Expenner

![Infrastructure](./expenner-infra.png)

## Modules

The infrastructure is divided into multiple modules and state files for better organization and maintainability. Each module is responsible for a specific part of the infrastructure. The modules are as follows:

- **00-prerequisites**: Contains the backend configuration for the terraform state file.
- **01-networking**: Contains the networking resources like VPC, Subnets, Security Groups, etc.
- **02-storage**: Contains the resources for the storage like S3, ECR, etc.
- **02a-cognito**: Contains the resources for Cognito User Pool.
- **03-web**: Contains the resources for the web application, like CloudFront, Route53, WAF, ALB, etc.
- **03a-cloudflare**: Contains the resources for the Cloudflare DNS and WAF (optional).
- **04-data**: Contains the resources for the database like RDS, ElastiCache, etc.
- **05-application**: Contains the resources for the backend application like ECS.

## References

- [The Right way to structure Terraform Project!](https://ibatulanand.medium.com/the-right-way-to-structure-terraform-project-89a52d67e510)
- [Module creation - recommended pattern](https://developer.hashicorp.com/terraform/tutorials/modules/pattern-module-creation)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
