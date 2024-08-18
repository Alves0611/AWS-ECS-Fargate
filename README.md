
# AWS ECS Fargate - Infrastructure as Code with Terraform


This project demonstrates the implementation of an infrastructure on AWS using ECS Fargate for running containerized applications. The infrastructure was provisioned 100% with Terraform, organized into different modules to facilitate maintenance and scalability.

## Table of Contents
- [Architecture](#architecture)
- [About](#about)
- [Code Organization](#code-organization)
- [How to Use](#how-to-use)
- [Testing and Validation](#testing-and-validation)


## Architecture

The project architecture consists of the following components:

- **VPC**: Virtual Private Cloud on AWS with public and private subnets.
- **NAT Gateway/Instance**: To allow instances in private subnets to access the internet.
- **ALB (Application Load Balancer)**: Load balancing to distribute traffic to ECS tasks.
- **ECS Fargate**: Managed container service where applications are run.
- **Auto Scaling**: Automatic scaling of ECS tasks based on demand.
- **RDS (Relational Database Service)**: Relational database service.
- **Secrets Manager**: Secure management of secrets, such as RDS database credentials.
- **ECR (Elastic Container Registry)**: Secure repository to store, manage, and deploy Docker images.
- **Bastion Host**: For secure access to the infrastructure in private subnets.
- **Route 53**: DNS management for the application.



![](./images/architecture.drawio.svg)


## About

The objective of this project is to provision a robust and scalable infrastructure on AWS using AWS ECS Fargate to manage containerized applications. The entire infrastructure is created using Terraform, ensuring a declarative and reproducible approach.

I developed an API using Node.js that was deployed on this infrastructure. I also performed stress tests on the API using the K6 tool to ensure that the application and infrastructure are resilient under high load.

## Code Organization

The project is divided into several Terraform modules, each responsible for a specific component of the infrastructure:

- **00-remote-state**: Configuration of the remote backend for Terraform state storage.
- **01-network**: Provisioning of the VPC, subnets, and network components such as NAT Gateway/Instance.
- **02-bastion-host**: Configuration of the Bastion Host for secure access to the private network.
- **03-database**: Provisioning of the RDS database.
- **04-ecr**: Configuration of the Amazon Elastic Container Registry (ECR) for Docker image storage.
- **05-ecs**: Configuration of Amazon ECS Fargate, including tasks, services, and integration with the ALB.

Each module is autonomous and can be applied separately, allowing greater flexibility in managing the infrastructure.



## How to Use

### 1. Clone the repository to your local machine:

```git clone https://github.com/Alves0611/AWS-ECS-Fargate```


**Prerequisites**: Ensure that you have Terraform installed on your machine and AWS credentials configured.

**Terraform Initialization**: In the project's `terraform` directory, run the following command to initialize Terraform:

```bash
cd <directory-name>

terraform init
```

- To use the remote backend, run:

```bash
terraform init -backend=true -backend-config="config/dev/backend.hcl"
```

**Apply the configurations:** To provision the infrastructure, run:

```bash
terraform apply
```

**Destroy the infrastructure:** If you need to remove the provisioned infrastructure, use:

```bash
terraform destroy
```

## Testing and Validation

**Stress Testing**: I used the K6 tool to validate the resilience of the infrastructure under load.

**Monitoring**: CloudWatch is configured to monitor critical metrics of the application and infrastructure.
