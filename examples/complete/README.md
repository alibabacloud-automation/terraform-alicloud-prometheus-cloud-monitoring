# Complete Example

This example demonstrates how to use the comprehensive real-time monitoring module to deploy a complete cloud services monitoring solution through Managed Service for Prometheus on Alibaba Cloud.

## Overview

This example creates a production-ready monitoring infrastructure with the following components:

- **Network Infrastructure**: A VPC with multiple VSwitches across different availability zones for high availability
- **Compute Resources**: An ECS instance for application deployment with automated monitoring agent installation
- **Database Services**: An RDS MySQL database instance with proper account management and security configuration
- **Caching Layer**: A Redis instance for high-performance caching and session storage
- **Message Queue**: A RocketMQ instance for reliable message queuing and event streaming with ACL configuration
- **Service Registry**: An MSE cluster for service discovery and configuration management
- **Access Control**: A RAM user with necessary permissions for logging and monitoring services
- **Security**: Security groups and rules for network access control with least privilege principles

This example demonstrates enterprise-grade configurations suitable for production environments.

## Usage

To run this example, you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Prerequisites

Before running this example, ensure you have:

1. **Alibaba Cloud Account**: Valid account with sufficient permissions
2. **License Keys**: Both MSE and ARMS license keys (see License Keys section below)
3. **Terraform**: Version >= 1.0 installed
4. **Provider**: Alicloud provider >= 1.212.0

## Configuration

This complete example uses production-grade specifications:

- **ECS**: `ecs.t6-c1m2.large` (2 vCPU, 4 GB RAM)
- **RDS**: `mysql.n2.medium.1` with 50GB ESSD storage
- **Redis**: `redis.shard.small.2.ce` with 1 shard
- **RocketMQ**: `rmq.s2.2xlarge` with advanced ACL configuration
- **MSE**: Nacos cluster with 1 instance for development/testing

## Variables

Create a `terraform.tfvars` file with the following content:

```hcl
common_name = "monitoring-prod"
region      = "cn-hangzhou"

# Instance configuration
instance_config = {
  instance_type              = "ecs.t6-c1m2.large"
  system_disk_category       = "cloud_essd"
  password                   = "YourSecurePassword123!"
  internet_max_bandwidth_out = 5
}

# RDS configuration
rds_account_config = {
  account_type     = "Normal"
  account_name     = "monitoring_user"
  account_password = "YourDBPassword123!"
}

# Redis configuration
redis_instance_config = {
  engine_version = "7.0"
  instance_class = "redis.shard.small.2.ce"
  password       = "YourRedisPassword123!"
  shard_count    = 1
  security_ips   = ["192.168.0.0/16"]
}

# RocketMQ configuration
rocketmq_account_config = {
  account_status = "ENABLE"
  username       = "monitoring_rmq"
  password       = "YourRocketMQPassword123!"
}

# License keys (required)
mse_license_key  = "your-mse-license-key"
arms_license_key = "your-arms-license-key"
```

## License Keys

Before running this example, you need to obtain the required license keys:

### MSE License Key
1. Log in to the MSE console: https://mse.console.aliyun.com
2. Navigate to Governance Center > Application Governance
3. Select the region at the top
4. Click "View License Key" in the upper right corner to get the MSE License Key

### ARMS License Key
1. Log in to the ARMS console: https://arms.console.aliyun.com
2. Navigate to Access Center > Server Application > Java Application Monitoring
3. Select "Manual Installation" in the environment type settings on the Access tab
4. Get the value corresponding to the variable -Darms.licenseKey in the Install Agent step

## Outputs

This example outputs comprehensive information about all created resources:

- **Network**: VPC ID, VSwitch IDs, Security Group ID
- **Compute**: ECS instance ID, public/private IP addresses, web URL, login address
- **Database**: RDS instance ID, connection string, database name
- **Cache**: Redis instance ID, connection domain
- **Message Queue**: RocketMQ instance ID, endpoint URL, topic names, consumer group ID
- **Service Registry**: MSE cluster ID, alias name, Nacos URL
- **Access Control**: RAM user name, access key ID (secret is marked as sensitive)

## Important Notes

1. **Security**: 
   - Use strong passwords for all database and service accounts
   - The default security group rules allow access from 0.0.0.0/0 for demonstration purposes
   - Consider restricting access to specific IP ranges in production environments

2. **Costs**: 
   - This example creates multiple paid resources
   - Monitor your usage and costs through the Alibaba Cloud console
   - Consider using smaller instance types for development/testing

3. **License Keys**: 
   - Both MSE and ARMS license keys are required and must be valid for your account and region
   - Keep license keys secure and do not commit them to version control

4. **High Availability**:
   - Resources are distributed across multiple availability zones
   - Consider enabling backup and disaster recovery features for production use

## Troubleshooting

Common issues and solutions:

- **License Key Errors**: Ensure license keys are valid and match your account/region
- **Zone Availability**: Some instance types may not be available in all zones
- **Resource Limits**: Check your account limits for ECS, RDS, and other resources
- **Network Connectivity**: Verify security group rules and VPC configuration