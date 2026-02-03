data "alicloud_regions" "current" {
  current = true
}

# VPC resource
resource "alicloud_vpc" "this" {
  cidr_block = var.vpc_config.cidr_block
  vpc_name   = var.vpc_config.vpc_name
}

# VSwitch resources with for_each aggregation
resource "alicloud_vswitch" "vswitches" {
  for_each = var.vswitches_config

  vpc_id       = alicloud_vpc.this.id
  cidr_block   = each.value.cidr_block
  zone_id      = each.value.zone_id
  vswitch_name = each.value.vswitch_name
}

# Security Group
resource "alicloud_security_group" "this" {
  vpc_id              = alicloud_vpc.this.id
  security_group_name = var.security_group_config.security_group_name
  description         = var.security_group_config.description
}

# Security Group Rules with for_each aggregation
resource "alicloud_security_group_rule" "this" {
  for_each = var.security_group_rules_config

  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  nic_type          = each.value.nic_type
  policy            = each.value.policy
  port_range        = each.value.port_range
  priority          = each.value.priority
  security_group_id = alicloud_security_group.this.id
  cidr_ip           = each.value.cidr_ip
}

# ECS Instance
resource "alicloud_instance" "this" {
  instance_name              = var.instance_config.instance_name
  image_id                   = var.instance_config.image_id
  instance_type              = var.instance_config.instance_type
  system_disk_category       = var.instance_config.system_disk_category
  security_groups            = [alicloud_security_group.this.id]
  vswitch_id                 = alicloud_vswitch.vswitches[var.instance_config.vswitch_key].id
  password                   = var.instance_config.password
  internet_max_bandwidth_out = var.instance_config.internet_max_bandwidth_out
}

# ECS Command
resource "alicloud_ecs_command" "this" {
  name            = var.ecs_command_config.name
  command_content = base64encode(var.custom_ecs_command_script != null ? var.custom_ecs_command_script : local.default_ecs_command_script)
  working_dir     = var.ecs_command_config.working_dir
  type            = var.ecs_command_config.type
  timeout         = var.ecs_command_config.timeout
}

# ECS Invocation
resource "alicloud_ecs_invocation" "this" {
  instance_id = [alicloud_instance.this.id]
  command_id  = alicloud_ecs_command.this.id

  timeouts {
    create = var.ecs_invocation_config.timeout
  }

  depends_on = [
    alicloud_instance.this,
    alicloud_db_instance.this,
    alicloud_db_database.this,
    alicloud_kvstore_instance.this,
    alicloud_rocketmq_instance.this,
    alicloud_rocketmq_acl.this,
    alicloud_mse_cluster.this
  ]
}

# RDS Instance
resource "alicloud_db_instance" "this" {
  instance_type            = var.rds_instance_config.instance_type
  zone_id                  = alicloud_vswitch.vswitches[var.rds_instance_config.vswitch_key].zone_id
  instance_storage         = var.rds_instance_config.instance_storage
  category                 = var.rds_instance_config.category
  db_instance_storage_type = var.rds_instance_config.db_instance_storage_type
  vswitch_id               = alicloud_vswitch.vswitches[var.rds_instance_config.vswitch_key].id
  engine                   = var.rds_instance_config.engine
  vpc_id                   = alicloud_vpc.this.id
  engine_version           = var.rds_instance_config.engine_version
  security_ips             = var.rds_instance_config.security_ips
}

# RDS Account
resource "alicloud_rds_account" "this" {
  db_instance_id   = alicloud_db_instance.this.id
  account_type     = var.rds_account_config.account_type
  account_name     = var.rds_account_config.account_name
  account_password = var.rds_account_config.account_password
}

# RDS Database
resource "alicloud_db_database" "this" {
  character_set  = var.rds_database_config.character_set
  instance_id    = alicloud_db_instance.this.id
  data_base_name = var.rds_database_config.name
}

# RDS Account Privilege
resource "alicloud_db_account_privilege" "this" {
  privilege    = var.rds_account_privilege_config.privilege
  instance_id  = alicloud_db_instance.this.id
  account_name = var.rds_account_config.account_name
  db_names     = [alicloud_db_database.this.data_base_name]

  depends_on = [
    alicloud_db_database.this,
    alicloud_rds_account.this
  ]
}

# Redis Instance
resource "alicloud_kvstore_instance" "this" {
  engine_version   = var.redis_instance_config.engine_version
  zone_id          = alicloud_vswitch.vswitches[var.redis_instance_config.vswitch_key].zone_id
  vswitch_id       = alicloud_vswitch.vswitches[var.redis_instance_config.vswitch_key].id
  instance_class   = var.redis_instance_config.instance_class
  password         = var.redis_instance_config.password
  shard_count      = var.redis_instance_config.shard_count
  db_instance_name = var.redis_instance_config.db_instance_name
  security_ips     = var.redis_instance_config.security_ips
}

# RocketMQ Instance
resource "alicloud_rocketmq_instance" "this" {

  product_info {
    msg_process_spec       = var.rocketmq_instance_config.msg_process_spec
    message_retention_time = var.rocketmq_instance_config.message_retention_time
  }

  sub_series_code = var.rocketmq_instance_config.sub_series_code
  series_code     = var.rocketmq_instance_config.series_code
  payment_type    = var.rocketmq_instance_config.payment_type
  instance_name   = var.rocketmq_instance_config.instance_name
  service_code    = var.rocketmq_instance_config.service_code

  network_info {
    vpc_info {
      vpc_id = alicloud_vpc.this.id
      vswitches {
        vswitch_id = alicloud_vswitch.vswitches[var.rocketmq_instance_config.vswitch_key].id
      }
    }
    internet_info {
      internet_spec = var.rocketmq_instance_config.internet_spec
      flow_out_type = var.rocketmq_instance_config.flow_out_type
    }
  }

  acl_info {
    acl_types             = var.rocketmq_instance_config.acl_types
    default_vpc_auth_free = var.rocketmq_instance_config.default_vpc_auth_free
  }
}

# RocketMQ Account
resource "alicloud_rocketmq_account" "this" {
  account_status = var.rocketmq_account_config.account_status
  instance_id    = alicloud_rocketmq_instance.this.id
  username       = var.rocketmq_account_config.username
  password       = var.rocketmq_account_config.password
}

# RocketMQ Topics with for_each aggregation
resource "alicloud_rocketmq_topic" "topics" {
  for_each = var.rocketmq_topics_config

  instance_id  = alicloud_rocketmq_instance.this.id
  remark       = each.value.remark != null ? each.value.remark : ""
  message_type = each.value.message_type
  topic_name   = each.value.topic_name
}

# RocketMQ Consumer Group
resource "alicloud_rocketmq_consumer_group" "this" {
  consumer_group_id   = var.rocketmq_consumer_group_config.consumer_group_id
  instance_id         = alicloud_rocketmq_instance.this.id
  delivery_order_type = var.rocketmq_consumer_group_config.delivery_order_type

  consume_retry_policy {
    retry_policy    = var.rocketmq_consumer_group_config.retry_policy
    max_retry_times = var.rocketmq_consumer_group_config.max_retry_times
  }
}

# RocketMQ ACLs with for_each aggregation
resource "alicloud_rocketmq_acl" "this" {
  for_each = var.rocketmq_acls_config

  actions       = each.value.actions
  instance_id   = alicloud_rocketmq_instance.this.id
  username      = alicloud_rocketmq_account.this.username
  resource_name = each.value.resource_type == "Topic" ? alicloud_rocketmq_topic.topics[each.value.resource_key].topic_name : alicloud_rocketmq_consumer_group.this.consumer_group_id
  resource_type = each.value.resource_type
  decision      = each.value.decision
  ip_whitelists = each.value.ip_whitelists
}

# MSE Cluster
resource "alicloud_mse_cluster" "this" {
  vpc_id                = alicloud_vpc.this.id
  vswitch_id            = alicloud_vswitch.vswitches[var.mse_cluster_config.vswitch_key].id
  mse_version           = var.mse_cluster_config.mse_version
  instance_count        = var.mse_cluster_config.instance_count
  cluster_version       = var.mse_cluster_config.cluster_version
  cluster_type          = var.mse_cluster_config.cluster_type
  cluster_specification = var.mse_cluster_config.cluster_specification
  net_type              = var.mse_cluster_config.net_type
  pub_network_flow      = var.mse_cluster_config.pub_network_flow
  cluster_alias_name    = var.mse_cluster_config.cluster_alias_name
}

data "alicloud_mse_clusters" "mse_micro_registry_instance" {
  enable_details = "true"
  ids            = [alicloud_mse_cluster.this.id]
}

# Default ECS command script
locals {
  default_ecs_command_script = <<-EOF
cat << EOT >> ~/.bash_profile
export REGION=${data.alicloud_regions.current.regions[0].id}
export DB_URL=${alicloud_db_instance.this.connection_string}:3306/flashsale
export DB_USERNAME=${alicloud_rds_account.this.account_name}
export DB_PASSWORD=${alicloud_rds_account.this.account_password}
export REDIS_HOST=${alicloud_kvstore_instance.this.connection_domain}
export REDIS_PASSWORD=${alicloud_kvstore_instance.this.password}
export NACOS_URL=${data.alicloud_mse_clusters.mse_micro_registry_instance.clusters[0].intranet_domain}:8848
export ROCKETMQ_ENDPOINT=${alicloud_rocketmq_instance.this.network_info[0].endpoints[0].endpoint_url}
export ROCKETMQ_USERNAME=${alicloud_rocketmq_account.this.username}
export ROCKETMQ_PASSWORD=${alicloud_rocketmq_account.this.password}
export MSE_LICENSE_KEY=${var.mse_license_key}
export ARMS_LICENSE_KEY=${var.arms_license_key}
EOT

source ~/.bash_profile

curl -fsSL https://help-static-aliyun-doc.aliyuncs.com/install-script/comprehensive-real-time-monitoring-of-cloud-services-through-managed-service-for-prometheus/install.sh | bash
EOF
}