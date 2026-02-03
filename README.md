# Alicloud Comprehensive Real-Time Monitoring Terraform Module

================================================ 

# terraform-alicloud-comprehensive-monitoring

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-comprehensive-monitoring/blob/main/README-CN.md)

Terraform module which creates a comprehensive real-time monitoring solution through Managed Service for Prometheus on Alibaba Cloud. This module provisions a complete monitoring infrastructure including VPC, ECS, RDS, Redis, RocketMQ, and MSE services with integrated monitoring and logging capabilities for cloud-native applications. This solution enables enterprises to implement [comprehensive real-time monitoring of cloud services through managed service for Prometheus](https://www.aliyun.com/solution/tech-solution/comprehensive-real-time-monitoring-of-cloud-services-through-managed-service-for-prometheus), providing unified observability across distributed systems.

## Usage

This module creates a complete cloud services monitoring solution with the following components:
- VPC and VSwitches for network isolation across multiple availability zones
- ECS instance for application deployment with automated monitoring agent installation
- RDS MySQL database for data persistence with connection pooling
- Redis for high-performance caching and session storage
- RocketMQ for reliable message queuing and event streaming
- MSE cluster for service registry and configuration management
- RAM user with necessary permissions for logging and monitoring services
- Security groups and rules for network access control

```terraform
module "monitoring_solution" {
  source = "alibabacloud-automation/comprehensive-monitoring/alicloud"

  common_name = "monitoring-prod"
  region      = "cn-hangzhou"

  vpc_config = {
    cidr_block = "192.168.0.0/16"
    vpc_name   = "monitoring-vpc"
  }

  vswitches_config = {
    ecs_vswitch = {
      cidr_block = "192.168.1.0/24"
      zone_id    = "cn-hangzhou-h"
    }
    rds_vswitch = {
      cidr_block = "192.168.2.0/24"
      zone_id    = "cn-hangzhou-i"
    }
    redis_vswitch = {
      cidr_block = "192.168.3.0/24"
      zone_id    = "cn-hangzhou-j"
    }
  }

  instance_config = {
    image_id             = "aliyun_3_x64_20G_alibase_20240819.vhd"
    instance_type        = "ecs.t6-c1m2.large"
    system_disk_category = "cloud_essd"
    password             = "YourSecurePassword123!"
    vswitch_key          = "ecs_vswitch"
  }

  rds_account_config = {
    account_type     = "Normal"
    account_name     = "monitoring_user"
    account_password = "YourDBPassword123!"
  }

  redis_instance_config = {
    engine_version = "7.0"
    zone_id        = "cn-hangzhou-j"
    instance_class = "redis.shard.small.2.ce"
    password       = "YourRedisPassword123!"
    shard_count    = 1
    security_ips   = ["192.168.0.0/16"]
    vswitch_key    = "redis_vswitch"
  }

  rocketmq_account_config = {
    account_status = "ENABLE"
    username       = "monitoring_rmq"
    password       = "YourRocketMQPassword123!"
  }

  mse_license_key  = var.mse_license_key
  arms_license_key = var.arms_license_key
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-comprehensive-monitoring/tree/main/examples/complete)
* [Basic Example](https://github.com/alibabacloud-automation/terraform-alicloud-comprehensive-monitoring/tree/main/examples/basic)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.212.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.212.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_db_account_privilege.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_account_privilege) | resource |
| [alicloud_db_database.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_database) | resource |
| [alicloud_db_instance.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_instance) | resource |
| [alicloud_ecs_command.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_command) | resource |
| [alicloud_ecs_invocation.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_invocation) | resource |
| [alicloud_instance.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_kvstore_instance.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/kvstore_instance) | resource |
| [alicloud_mse_cluster.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/mse_cluster) | resource |
| [alicloud_rds_account.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rds_account) | resource |
| [alicloud_rocketmq_account.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_account) | resource |
| [alicloud_rocketmq_acl.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_acl) | resource |
| [alicloud_rocketmq_consumer_group.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_consumer_group) | resource |
| [alicloud_rocketmq_instance.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_instance) | resource |
| [alicloud_rocketmq_topic.topics](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_topic) | resource |
| [alicloud_security_group.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.vswitches](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_mse_clusters.mse_micro_registry_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/mse_clusters) | data source |
| [alicloud_regions.current](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arms_license_key"></a> [arms\_license\_key](#input\_arms\_license\_key) | ARMS License Key for the current environment | `string` | `""` | no |
| <a name="input_custom_ecs_command_script"></a> [custom\_ecs\_command\_script](#input\_custom\_ecs\_command\_script) | Custom ECS command script to override the default script. If not provided, the default script will be used. | `string` | `null` | no |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | The parameters of ECS command. The attribute 'name' is required. | <pre>object({<br/>    name        = string<br/>    working_dir = string<br/>    type        = string<br/>    timeout     = number<br/>  })</pre> | <pre>{<br/>  "name": "command-genlog-loongcollector-monitoring",<br/>  "timeout": 3600,<br/>  "type": "RunShellScript",<br/>  "working_dir": "/root"<br/>}</pre> | no |
| <a name="input_ecs_invocation_config"></a> [ecs\_invocation\_config](#input\_ecs\_invocation\_config) | The parameters of ECS invocation. | <pre>object({<br/>    timeout = string<br/>  })</pre> | <pre>{<br/>  "timeout": "35m"<br/>}</pre> | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | The parameters of ECS instance. The attributes 'image\_id', 'instance\_type', 'system\_disk\_category', 'password', 'vswitch\_key' are required. | <pre>object({<br/>    instance_name              = optional(string, null)<br/>    image_id                   = string<br/>    instance_type              = string<br/>    system_disk_category       = string<br/>    password                   = string<br/>    internet_max_bandwidth_out = optional(number, 5)<br/>    vswitch_key                = string<br/>  })</pre> | <pre>{<br/>  "image_id": null,<br/>  "instance_type": "ecs.t6-c1m2.large",<br/>  "password": null,<br/>  "system_disk_category": "cloud_essd",<br/>  "vswitch_key": "ecs_vswitch"<br/>}</pre> | no |
| <a name="input_mse_cluster_config"></a> [mse\_cluster\_config](#input\_mse\_cluster\_config) | The parameters of MSE cluster. All attributes are required. | <pre>object({<br/>    mse_version           = string<br/>    instance_count        = number<br/>    cluster_version       = string<br/>    cluster_type          = string<br/>    cluster_specification = string<br/>    net_type              = string<br/>    pub_network_flow      = number<br/>    cluster_alias_name    = string<br/>    vswitch_key           = string<br/>  })</pre> | <pre>{<br/>  "cluster_alias_name": "my-nacos-monitoring",<br/>  "cluster_specification": "MSE_SC_1_2_60_c",<br/>  "cluster_type": "Nacos-Ans",<br/>  "cluster_version": "NACOS_2_0_0",<br/>  "instance_count": 1,<br/>  "mse_version": "mse_dev",<br/>  "net_type": "privatenet",<br/>  "pub_network_flow": 0,<br/>  "vswitch_key": "ecs_vswitch"<br/>}</pre> | no |
| <a name="input_mse_license_key"></a> [mse\_license\_key](#input\_mse\_license\_key) | MSE License Key for the current environment | `string` | `""` | no |
| <a name="input_rds_account_config"></a> [rds\_account\_config](#input\_rds\_account\_config) | The parameters of RDS account. All attributes are required. | <pre>object({<br/>    account_type     = string<br/>    account_name     = string<br/>    account_password = string<br/>  })</pre> | <pre>{<br/>  "account_name": "db_normal_account",<br/>  "account_password": null,<br/>  "account_type": "Normal"<br/>}</pre> | no |
| <a name="input_rds_account_privilege_config"></a> [rds\_account\_privilege\_config](#input\_rds\_account\_privilege\_config) | The parameters of RDS account privilege. | <pre>object({<br/>    privilege = string<br/>  })</pre> | <pre>{<br/>  "privilege": "ReadWrite"<br/>}</pre> | no |
| <a name="input_rds_database_config"></a> [rds\_database\_config](#input\_rds\_database\_config) | The parameters of RDS database. All attributes are required. | <pre>object({<br/>    character_set = string<br/>    name          = string<br/>  })</pre> | <pre>{<br/>  "character_set": "utf8",<br/>  "name": "flashsale"<br/>}</pre> | no |
| <a name="input_rds_instance_config"></a> [rds\_instance\_config](#input\_rds\_instance\_config) | The parameters of RDS instance. All attributes are required. | <pre>object({<br/>    instance_type            = string<br/>    instance_storage         = number<br/>    category                 = string<br/>    db_instance_storage_type = string<br/>    engine                   = string<br/>    engine_version           = string<br/>    security_ips             = list(string)<br/>    vswitch_key              = string<br/>  })</pre> | <pre>{<br/>  "category": "Basic",<br/>  "db_instance_storage_type": "cloud_essd",<br/>  "engine": "MySQL",<br/>  "engine_version": "8.0",<br/>  "instance_storage": 50,<br/>  "instance_type": "mysql.n2.medium.1",<br/>  "security_ips": [<br/>    "192.168.0.0/16"<br/>  ],<br/>  "vswitch_key": "rds_vswitch"<br/>}</pre> | no |
| <a name="input_redis_instance_config"></a> [redis\_instance\_config](#input\_redis\_instance\_config) | The parameters of Redis instance. All attributes are required. | <pre>object({<br/>    engine_version   = string<br/>    instance_class   = string<br/>    password         = string<br/>    shard_count      = number<br/>    db_instance_name = string<br/>    security_ips     = list(string)<br/>    vswitch_key      = string<br/>  })</pre> | <pre>{<br/>  "db_instance_name": "flashsale-redis-monitoring",<br/>  "engine_version": "7.0",<br/>  "instance_class": "redis.shard.small.2.ce",<br/>  "password": null,<br/>  "security_ips": [<br/>    "192.168.0.0/16"<br/>  ],<br/>  "shard_count": 1,<br/>  "vswitch_key": "redis_vswitch"<br/>}</pre> | no |
| <a name="input_rocketmq_account_config"></a> [rocketmq\_account\_config](#input\_rocketmq\_account\_config) | The parameters of RocketMQ account. All attributes are required. | <pre>object({<br/>    account_status = string<br/>    username       = string<br/>    password       = string<br/>  })</pre> | <pre>{<br/>  "account_status": "ENABLE",<br/>  "password": null,<br/>  "username": null<br/>}</pre> | no |
| <a name="input_rocketmq_acls_config"></a> [rocketmq\_acls\_config](#input\_rocketmq\_acls\_config) | The parameters of RocketMQ ACLs. | <pre>map(object({<br/>    actions       = list(string)<br/>    resource_type = string<br/>    resource_key  = optional(string, null)<br/>    decision      = string<br/>    ip_whitelists = list(string)<br/>  }))</pre> | <pre>{<br/>  "consumer_group_acl": {<br/>    "actions": [<br/>      "Sub"<br/>    ],<br/>    "decision": "Allow",<br/>    "ip_whitelists": [<br/>      "192.168.0.0/16"<br/>    ],<br/>    "resource_type": "Group"<br/>  },<br/>  "topic1_acl": {<br/>    "actions": [<br/>      "Pub",<br/>      "Sub"<br/>    ],<br/>    "decision": "Allow",<br/>    "ip_whitelists": [<br/>      "192.168.0.0/16"<br/>    ],<br/>    "resource_key": "topic1",<br/>    "resource_type": "Topic"<br/>  },<br/>  "topic2_acl": {<br/>    "actions": [<br/>      "Pub",<br/>      "Sub"<br/>    ],<br/>    "decision": "Allow",<br/>    "ip_whitelists": [<br/>      "192.168.0.0/16"<br/>    ],<br/>    "resource_key": "topic2",<br/>    "resource_type": "Topic"<br/>  },<br/>  "topic3_acl": {<br/>    "actions": [<br/>      "Pub",<br/>      "Sub"<br/>    ],<br/>    "decision": "Allow",<br/>    "ip_whitelists": [<br/>      "192.168.0.0/16"<br/>    ],<br/>    "resource_key": "topic3",<br/>    "resource_type": "Topic"<br/>  }<br/>}</pre> | no |
| <a name="input_rocketmq_consumer_group_config"></a> [rocketmq\_consumer\_group\_config](#input\_rocketmq\_consumer\_group\_config) | The parameters of RocketMQ consumer group. All attributes are required. | <pre>object({<br/>    consumer_group_id   = string<br/>    delivery_order_type = string<br/>    retry_policy        = string<br/>    max_retry_times     = number<br/>  })</pre> | <pre>{<br/>  "consumer_group_id": "flashsale-service-consumer-group",<br/>  "delivery_order_type": "Concurrently",<br/>  "max_retry_times": 5,<br/>  "retry_policy": "DefaultRetryPolicy"<br/>}</pre> | no |
| <a name="input_rocketmq_instance_config"></a> [rocketmq\_instance\_config](#input\_rocketmq\_instance\_config) | The parameters of RocketMQ instance. All attributes are required. | <pre>object({<br/>    msg_process_spec       = string<br/>    message_retention_time = string<br/>    sub_series_code        = string<br/>    series_code            = string<br/>    payment_type           = string<br/>    instance_name          = string<br/>    service_code           = string<br/>    internet_spec          = string<br/>    flow_out_type          = string<br/>    acl_types              = list(string)<br/>    default_vpc_auth_free  = bool<br/>    vswitch_key            = string<br/>  })</pre> | <pre>{<br/>  "acl_types": [<br/>    "default",<br/>    "apache_acl"<br/>  ],<br/>  "default_vpc_auth_free": false,<br/>  "flow_out_type": "uninvolved",<br/>  "instance_name": "ROCKETMQ5-monitoring",<br/>  "internet_spec": "disable",<br/>  "message_retention_time": "70",<br/>  "msg_process_spec": "rmq.s2.2xlarge",<br/>  "payment_type": "PayAsYouGo",<br/>  "series_code": "standard",<br/>  "service_code": "rmq",<br/>  "sub_series_code": "cluster_ha",<br/>  "vswitch_key": "ecs_vswitch"<br/>}</pre> | no |
| <a name="input_rocketmq_topics_config"></a> [rocketmq\_topics\_config](#input\_rocketmq\_topics\_config) | The parameters of RocketMQ topics. | <pre>map(object({<br/>    remark       = optional(string, "")<br/>    message_type = string<br/>    topic_name   = string<br/>  }))</pre> | <pre>{<br/>  "topic1": {<br/>    "message_type": "NORMAL",<br/>    "remark": "预扣库存成功后订单创建失败",<br/>    "topic_name": "order-fail-after-pre-deducted-inventory"<br/>  },<br/>  "topic2": {<br/>    "message_type": "NORMAL",<br/>    "remark": "库存系统扣减库存成功后订单创建失败",<br/>    "topic_name": "order-fail-after-deducted-inventory"<br/>  },<br/>  "topic3": {<br/>    "message_type": "TRANSACTION",<br/>    "remark": "订单创建成功",<br/>    "topic_name": "order-success"<br/>  }<br/>}</pre> | no |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | The parameters of security group. | <pre>object({<br/>    security_group_name = optional(string, null)<br/>    description         = optional(string, "Security group for monitoring solution")<br/>  })</pre> | <pre>{<br/>  "description": "Security group for monitoring solution"<br/>}</pre> | no |
| <a name="input_security_group_rules_config"></a> [security\_group\_rules\_config](#input\_security\_group\_rules\_config) | The parameters of security group rules. | <pre>map(object({<br/>    type        = string<br/>    ip_protocol = string<br/>    nic_type    = string<br/>    policy      = string<br/>    port_range  = string<br/>    priority    = number<br/>    cidr_ip     = string<br/>  }))</pre> | <pre>{<br/>  "allow_ssh": {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "nic_type": "intranet",<br/>    "policy": "accept",<br/>    "port_range": "22/22",<br/>    "priority": 1,<br/>    "type": "ingress"<br/>  },<br/>  "allow_web": {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "nic_type": "intranet",<br/>    "policy": "accept",<br/>    "port_range": "80/80",<br/>    "priority": 1,<br/>    "type": "ingress"<br/>  }<br/>}</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | The parameters of VPC. The attribute 'cidr\_block' is required. | <pre>object({<br/>    cidr_block = string<br/>    vpc_name   = optional(string, null)<br/>  })</pre> | <pre>{<br/>  "cidr_block": "192.168.0.0/16"<br/>}</pre> | no |
| <a name="input_vswitches_config"></a> [vswitches\_config](#input\_vswitches\_config) | The parameters of VSwitches. The attributes 'cidr\_block' and 'zone\_id' are required. | <pre>map(object({<br/>    cidr_block   = string<br/>    zone_id      = string<br/>    vswitch_name = optional(string, null)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_instance_id"></a> [ecs\_instance\_id](#output\_ecs\_instance\_id) | The ID of the ECS instance |
| <a name="output_ecs_instance_private_ip"></a> [ecs\_instance\_private\_ip](#output\_ecs\_instance\_private\_ip) | The private IP address of the ECS instance |
| <a name="output_ecs_instance_public_ip"></a> [ecs\_instance\_public\_ip](#output\_ecs\_instance\_public\_ip) | The public IP address of the ECS instance |
| <a name="output_ecs_login_address"></a> [ecs\_login\_address](#output\_ecs\_login\_address) | The ECS workbench login address for the deployed application |
| <a name="output_mse_cluster_alias_name"></a> [mse\_cluster\_alias\_name](#output\_mse\_cluster\_alias\_name) | The alias name of the MSE cluster |
| <a name="output_mse_cluster_id"></a> [mse\_cluster\_id](#output\_mse\_cluster\_id) | The ID of the MSE cluster |
| <a name="output_nacos_url"></a> [nacos\_url](#output\_nacos\_url) | The Nacos server URL |
| <a name="output_rds_connection_string"></a> [rds\_connection\_string](#output\_rds\_connection\_string) | The connection string of the RDS instance |
| <a name="output_rds_database_name"></a> [rds\_database\_name](#output\_rds\_database\_name) | The name of the RDS database |
| <a name="output_rds_instance_id"></a> [rds\_instance\_id](#output\_rds\_instance\_id) | The ID of the RDS instance |
| <a name="output_redis_connection_domain"></a> [redis\_connection\_domain](#output\_redis\_connection\_domain) | The connection domain of the Redis instance |
| <a name="output_redis_instance_id"></a> [redis\_instance\_id](#output\_redis\_instance\_id) | The ID of the Redis instance |
| <a name="output_rocketmq_consumer_group_id"></a> [rocketmq\_consumer\_group\_id](#output\_rocketmq\_consumer\_group\_id) | The ID of the RocketMQ consumer group |
| <a name="output_rocketmq_endpoint"></a> [rocketmq\_endpoint](#output\_rocketmq\_endpoint) | The endpoint URL of the RocketMQ instance |
| <a name="output_rocketmq_instance_id"></a> [rocketmq\_instance\_id](#output\_rocketmq\_instance\_id) | The ID of the RocketMQ instance |
| <a name="output_rocketmq_topic_names"></a> [rocketmq\_topic\_names](#output\_rocketmq\_topic\_names) | The names of the RocketMQ topics |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vswitch_ids"></a> [vswitch\_ids](#output\_vswitch\_ids) | The IDs of the VSwitches |
| <a name="output_web_url"></a> [web\_url](#output\_web\_url) | The URL of the web application |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)