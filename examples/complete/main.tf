provider "alicloud" {
  region = "cn-hangzhou"
}

# Data sources to get zone information
data "alicloud_zones" "ecs_zones" {
  available_disk_category     = "cloud_essd"
  available_resource_creation = "VSwitch"
  available_instance_type     = var.instance_config.instance_type
}

data "alicloud_db_zones" "rds_zones" {
  engine                   = "MySQL"
  engine_version           = "8.0"
  instance_charge_type     = "PostPaid"
  category                 = "Basic"
  db_instance_storage_type = "cloud_essd"
}

data "alicloud_kvstore_zones" "redis_zones" {
  instance_charge_type = "PostPaid"
  engine               = "Redis"
  product_type         = "OnECS"
}

data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_20G_alibase_.*"
  most_recent = true
  owners      = "system"
}

module "monitoring_solution" {
  source = "../../"

  vpc_config = var.vpc_config

  vswitches_config = {
    ecs_vswitch = {
      cidr_block = "192.168.1.0/24"
      zone_id    = data.alicloud_zones.ecs_zones.zones[0].id
    }
    rds_vswitch = {
      cidr_block = "192.168.2.0/24"
      zone_id    = data.alicloud_db_zones.rds_zones.zones[0].id
    }
    redis_vswitch = {
      cidr_block = "192.168.3.0/24"
      zone_id    = data.alicloud_kvstore_zones.redis_zones.zones[0].id
    }
  }

  # 安全组规则配置，按照默认值结构但使用交换机网段
  security_group_rules_config = {
    allow_ssh = {
      type        = "ingress"
      ip_protocol = "tcp"
      nic_type    = "intranet"
      policy      = "accept"
      port_range  = "22/22"
      priority    = 1
      cidr_ip     = "192.168.1.0/24" # 使用ECS交换机网段替代默认的 0.0.0.0/0
    }
    allow_web = {
      type        = "ingress"
      ip_protocol = "tcp"
      nic_type    = "intranet"
      policy      = "accept"
      port_range  = "80/80"
      priority    = 1
      cidr_ip     = "192.168.1.0/24" # 使用ECS交换机网段替代默认的 0.0.0.0/0
    }
  }

  instance_config = {
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = var.instance_config.instance_type
    system_disk_category       = var.instance_config.system_disk_category
    password                   = var.instance_config.password
    internet_max_bandwidth_out = var.instance_config.internet_max_bandwidth_out
    vswitch_key                = "ecs_vswitch"
  }

  ecs_command_config = {
    name        = "command-genlog-loongcollector-monitoring"
    working_dir = "/root"
    type        = "RunShellScript"
    timeout     = 3600
  }

  ecs_invocation_config = {
    timeout = "15m"
  }

  rds_instance_config = {
    instance_type            = var.rds_instance_config.instance_type
    instance_storage         = var.rds_instance_config.instance_storage
    category                 = var.rds_instance_config.category
    db_instance_storage_type = var.rds_instance_config.db_instance_storage_type
    engine                   = var.rds_instance_config.engine
    engine_version           = var.rds_instance_config.engine_version
    security_ips             = var.rds_instance_config.security_ips
    vswitch_key              = "rds_vswitch"
  }

  rds_account_config = var.rds_account_config

  redis_instance_config = {
    engine_version   = var.redis_instance_config.engine_version
    instance_class   = var.redis_instance_config.instance_class
    password         = var.redis_instance_config.password
    shard_count      = var.redis_instance_config.shard_count
    db_instance_name = "flashsale-redis-example"
    security_ips     = var.redis_instance_config.security_ips
    vswitch_key      = "redis_vswitch"
  }

  # Add missing RocketMQ instance configuration
  rocketmq_instance_config = {
    msg_process_spec       = "rmq.s2.2xlarge"
    message_retention_time = "70"
    sub_series_code        = "cluster_ha"
    series_code            = "standard"
    payment_type           = "PayAsYouGo"
    instance_name          = "ROCKETMQ5-example"
    service_code           = "rmq"
    internet_spec          = "disable"
    flow_out_type          = "uninvolved"
    acl_types              = ["default", "apache_acl"]
    default_vpc_auth_free  = false
    vswitch_key            = "ecs_vswitch"
  }

  rocketmq_account_config = var.rocketmq_account_config

  mse_cluster_config = {
    mse_version           = var.mse_cluster_config.mse_version
    instance_count        = var.mse_cluster_config.instance_count
    cluster_version       = var.mse_cluster_config.cluster_version
    cluster_type          = var.mse_cluster_config.cluster_type
    cluster_specification = var.mse_cluster_config.cluster_specification
    net_type              = var.mse_cluster_config.net_type
    pub_network_flow      = var.mse_cluster_config.pub_network_flow
    cluster_alias_name    = "my-nacos-example"
    vswitch_key           = "ecs_vswitch"
  }

  mse_license_key  = var.mse_license_key
  arms_license_key = var.arms_license_key
}