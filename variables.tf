
# Network-related variables
variable "vpc_config" {
  type = object({
    cidr_block = string
    vpc_name   = optional(string, null)
  })
  description = "The parameters of VPC. The attribute 'cidr_block' is required."
  default = {
    cidr_block = "192.168.0.0/16"
  }
}

variable "vswitches_config" {
  type = map(object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string, null)
  }))
  description = "The parameters of VSwitches. The attributes 'cidr_block' and 'zone_id' are required."
}

variable "security_group_config" {
  type = object({
    security_group_name = optional(string, null)
    description         = optional(string, "Security group for monitoring solution")
  })
  description = "The parameters of security group."
  default = {
    description = "Security group for monitoring solution"
  }
}

variable "security_group_rules_config" {
  type = map(object({
    type        = string
    ip_protocol = string
    nic_type    = string
    policy      = string
    port_range  = string
    priority    = number
    cidr_ip     = string
  }))
  description = "The parameters of security group rules."
  default = {
    allow_ssh = {
      type        = "ingress"
      ip_protocol = "tcp"
      nic_type    = "intranet"
      policy      = "accept"
      port_range  = "22/22"
      priority    = 1
      cidr_ip     = "0.0.0.0/0"
    }
    allow_web = {
      type        = "ingress"
      ip_protocol = "tcp"
      nic_type    = "intranet"
      policy      = "accept"
      port_range  = "80/80"
      priority    = 1
      cidr_ip     = "0.0.0.0/0"
    }
  }
}

variable "instance_config" {
  type = object({
    instance_name              = optional(string, null)
    image_id                   = string
    instance_type              = string
    system_disk_category       = string
    password                   = string
    internet_max_bandwidth_out = optional(number, 5)
    vswitch_key                = string
  })
  description = "The parameters of ECS instance. The attributes 'image_id', 'instance_type', 'system_disk_category', 'password', 'vswitch_key' are required."
  default = {
    image_id             = null
    instance_type        = "ecs.t6-c1m2.large"
    system_disk_category = "cloud_essd"
    password             = null
    vswitch_key          = "ecs_vswitch"
  }
}

variable "ecs_command_config" {
  type = object({
    name        = string
    working_dir = string
    type        = string
    timeout     = number
  })
  description = "The parameters of ECS command. The attribute 'name' is required."
  default = {
    name        = "command-genlog-loongcollector-monitoring"
    working_dir = "/root"
    type        = "RunShellScript"
    timeout     = 3600
  }
}

variable "ecs_invocation_config" {
  type = object({
    timeout = string
  })
  description = "The parameters of ECS invocation."
  default = {
    timeout = "35m"
  }
}

# RDS-related variables
variable "rds_instance_config" {
  type = object({
    instance_type            = string
    instance_storage         = number
    category                 = string
    db_instance_storage_type = string
    engine                   = string
    engine_version           = string
    security_ips             = list(string)
    vswitch_key              = string
  })
  description = "The parameters of RDS instance. All attributes are required."
  default = {
    instance_type            = "mysql.n2.medium.1"
    instance_storage         = 50
    category                 = "Basic"
    db_instance_storage_type = "cloud_essd"
    engine                   = "MySQL"
    engine_version           = "8.0"
    security_ips             = ["192.168.0.0/16"]
    vswitch_key              = "rds_vswitch"
  }
}

variable "rds_account_config" {
  type = object({
    account_type     = string
    account_name     = string
    account_password = string
  })
  description = "The parameters of RDS account. All attributes are required."
  default = {
    account_type     = "Normal"
    account_name     = "db_normal_account"
    account_password = null
  }
}

variable "rds_database_config" {
  type = object({
    character_set = string
    name          = string
  })
  description = "The parameters of RDS database. All attributes are required."
  default = {
    character_set = "utf8"
    name          = "flashsale"
  }
}

variable "rds_account_privilege_config" {
  type = object({
    privilege = string
  })
  description = "The parameters of RDS account privilege."
  default = {
    privilege = "ReadWrite"
  }
}

# Redis-related variables
variable "redis_instance_config" {
  type = object({
    engine_version   = string
    instance_class   = string
    password         = string
    shard_count      = number
    db_instance_name = string
    security_ips     = list(string)
    vswitch_key      = string
  })
  description = "The parameters of Redis instance. All attributes are required."
  default = {
    engine_version   = "7.0"
    instance_class   = "redis.shard.small.2.ce"
    password         = null
    shard_count      = 1
    db_instance_name = "flashsale-redis-monitoring"
    security_ips     = ["192.168.0.0/16"]
    vswitch_key      = "redis_vswitch"
  }
}

# RocketMQ-related variables
variable "rocketmq_instance_config" {
  type = object({
    msg_process_spec       = string
    message_retention_time = string
    sub_series_code        = string
    series_code            = string
    payment_type           = string
    instance_name          = string
    service_code           = string
    internet_spec          = string
    flow_out_type          = string
    acl_types              = list(string)
    default_vpc_auth_free  = bool
    vswitch_key            = string
  })
  description = "The parameters of RocketMQ instance. All attributes are required."
  default = {
    msg_process_spec       = "rmq.s2.2xlarge"
    message_retention_time = "70"
    sub_series_code        = "cluster_ha"
    series_code            = "standard"
    payment_type           = "PayAsYouGo"
    instance_name          = "ROCKETMQ5-monitoring"
    service_code           = "rmq"
    internet_spec          = "disable"
    flow_out_type          = "uninvolved"
    acl_types              = ["default", "apache_acl"]
    default_vpc_auth_free  = false
    vswitch_key            = "ecs_vswitch"
  }
}

variable "rocketmq_account_config" {
  type = object({
    account_status = string
    username       = string
    password       = string
  })
  description = "The parameters of RocketMQ account. All attributes are required."
  default = {
    account_status = "ENABLE"
    username       = null
    password       = null
  }
}

variable "rocketmq_topics_config" {
  type = map(object({
    remark       = optional(string, "")
    message_type = string
    topic_name   = string
  }))
  description = "The parameters of RocketMQ topics."
  default = {
    topic1 = {
      remark       = "预扣库存成功后订单创建失败"
      message_type = "NORMAL"
      topic_name   = "order-fail-after-pre-deducted-inventory"
    }
    topic2 = {
      remark       = "库存系统扣减库存成功后订单创建失败"
      message_type = "NORMAL"
      topic_name   = "order-fail-after-deducted-inventory"
    }
    topic3 = {
      remark       = "订单创建成功"
      message_type = "TRANSACTION"
      topic_name   = "order-success"
    }
  }
}

variable "rocketmq_consumer_group_config" {
  type = object({
    consumer_group_id   = string
    delivery_order_type = string
    retry_policy        = string
    max_retry_times     = number
  })
  description = "The parameters of RocketMQ consumer group. All attributes are required."
  default = {
    consumer_group_id   = "flashsale-service-consumer-group"
    delivery_order_type = "Concurrently"
    retry_policy        = "DefaultRetryPolicy"
    max_retry_times     = 5
  }
}

variable "rocketmq_acls_config" {
  type = map(object({
    actions       = list(string)
    resource_type = string
    resource_key  = optional(string, null)
    decision      = string
    ip_whitelists = list(string)
  }))
  description = "The parameters of RocketMQ ACLs."
  default = {
    topic1_acl = {
      actions       = ["Pub", "Sub"]
      resource_type = "Topic"
      resource_key  = "topic1"
      decision      = "Allow"
      ip_whitelists = ["192.168.0.0/16"]
    }
    topic2_acl = {
      actions       = ["Pub", "Sub"]
      resource_type = "Topic"
      resource_key  = "topic2"
      decision      = "Allow"
      ip_whitelists = ["192.168.0.0/16"]
    }
    topic3_acl = {
      actions       = ["Pub", "Sub"]
      resource_type = "Topic"
      resource_key  = "topic3"
      decision      = "Allow"
      ip_whitelists = ["192.168.0.0/16"]
    }
    consumer_group_acl = {
      actions       = ["Sub"]
      resource_type = "Group"
      decision      = "Allow"
      ip_whitelists = ["192.168.0.0/16"]
    }
  }
}

# MSE-related variables
variable "mse_cluster_config" {
  type = object({
    mse_version           = string
    instance_count        = number
    cluster_version       = string
    cluster_type          = string
    cluster_specification = string
    net_type              = string
    pub_network_flow      = number
    cluster_alias_name    = string
    vswitch_key           = string
  })
  description = "The parameters of MSE cluster. All attributes are required."
  default = {
    mse_version           = "mse_dev"
    instance_count        = 1
    cluster_version       = "NACOS_2_0_0"
    cluster_type          = "Nacos-Ans"
    cluster_specification = "MSE_SC_1_2_60_c"
    net_type              = "privatenet"
    pub_network_flow      = 0
    cluster_alias_name    = "my-nacos-monitoring"
    vswitch_key           = "ecs_vswitch"
  }
}

variable "mse_license_key" {
  type        = string
  description = "MSE License Key for the current environment"
  sensitive   = true
  default     = "" # 在实际部署时应替换为真实许可证密钥
}

variable "arms_license_key" {
  type        = string
  description = "ARMS License Key for the current environment"
  sensitive   = true
  default     = "" # 在实际部署时应替换为真实许可证密钥
}

variable "custom_ecs_command_script" {
  type        = string
  description = "Custom ECS command script to override the default script. If not provided, the default script will be used."
  default     = null
}