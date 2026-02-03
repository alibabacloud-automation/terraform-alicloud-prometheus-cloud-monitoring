
variable "vpc_config" {
  type = object({
    cidr_block = string
    vpc_name   = optional(string, null)
  })
  description = "The parameters of VPC. The attribute 'cidr_block' is required."
  default = {
    cidr_block = "192.168.0.0/16"
    vpc_name   = "monitoring-vpc"
  }
}

variable "instance_config" {
  type = object({
    instance_type              = string
    system_disk_category       = string
    password                   = string
    internet_max_bandwidth_out = optional(number, 5)
  })
  description = "The parameters of ECS instance. The attributes 'instance_type', 'system_disk_category', 'password' are required."
  default = {
    instance_type              = "ecs.t6-c1m2.large"
    system_disk_category       = "cloud_essd"
    password                   = "YourPassword123!"
    internet_max_bandwidth_out = 5
  }
}

variable "rds_instance_config" {
  type = object({
    instance_type            = string
    instance_storage         = number
    category                 = string
    db_instance_storage_type = string
    engine                   = string
    engine_version           = string
    security_ips             = list(string)
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
    account_password = "YourDBPassword123!"
  }
}

variable "redis_instance_config" {
  type = object({
    engine_version = string
    instance_class = string
    password       = string
    shard_count    = number
    security_ips   = list(string)
  })
  description = "The parameters of Redis instance."
  default = {
    engine_version = "7.0"
    instance_class = "redis.shard.small.2.ce"
    password       = "YourRedisPassword123!"
    shard_count    = 1
    security_ips   = ["192.168.0.0/16"]
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
    username       = "rmquser"
    password       = "YourRocketMQPassword123!"
  }
}

variable "mse_cluster_config" {
  type = object({
    mse_version           = string
    instance_count        = number
    cluster_version       = string
    cluster_type          = string
    cluster_specification = string
    net_type              = string
    pub_network_flow      = number
  })
  description = "The parameters of MSE cluster."
  default = {
    mse_version           = "mse_dev"
    instance_count        = 1
    cluster_version       = "NACOS_2_0_0"
    cluster_type          = "Nacos-Ans"
    cluster_specification = "MSE_SC_1_2_60_c"
    net_type              = "privatenet"
    pub_network_flow      = 0
  }
}

variable "mse_license_key" {
  type        = string
  description = "MSE License Key for the current environment"
  sensitive   = true
}

variable "arms_license_key" {
  type        = string
  description = "ARMS License Key for the current environment"
  sensitive   = true
}