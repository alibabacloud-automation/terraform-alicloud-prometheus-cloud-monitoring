# VPC outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.this.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = alicloud_vpc.this.cidr_block
}

# VSwitch outputs
output "vswitch_ids" {
  description = "The IDs of the VSwitches"
  value       = { for k, v in alicloud_vswitch.vswitches : k => v.id }
}

# Security Group outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.this.id
}


# ECS Instance outputs
output "ecs_instance_id" {
  description = "The ID of the ECS instance"
  value       = alicloud_instance.this.id
}

output "ecs_instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = alicloud_instance.this.public_ip
}

output "ecs_instance_private_ip" {
  description = "The private IP address of the ECS instance"
  value       = alicloud_instance.this.primary_ip_address
}

output "web_url" {
  description = "The URL of the web application"
  value       = "http://${alicloud_instance.this.public_ip}"
}

# RDS Instance outputs
output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = alicloud_db_instance.this.id
}

output "rds_connection_string" {
  description = "The connection string of the RDS instance"
  value       = alicloud_db_instance.this.connection_string
}

output "rds_database_name" {
  description = "The name of the RDS database"
  value       = alicloud_db_database.this.data_base_name
}

# Redis Instance outputs
output "redis_instance_id" {
  description = "The ID of the Redis instance"
  value       = alicloud_kvstore_instance.this.id
}

output "redis_connection_domain" {
  description = "The connection domain of the Redis instance"
  value       = alicloud_kvstore_instance.this.connection_domain
}

# RocketMQ Instance outputs
output "rocketmq_instance_id" {
  description = "The ID of the RocketMQ instance"
  value       = alicloud_rocketmq_instance.this.id
}

output "rocketmq_endpoint" {
  description = "The endpoint URL of the RocketMQ instance"
  value       = try(alicloud_rocketmq_instance.this.network_info[0].endpoints[0].endpoint_url, "")
}

output "rocketmq_topic_names" {
  description = "The names of the RocketMQ topics"
  value       = { for k, v in alicloud_rocketmq_topic.topics : k => v.topic_name }
}

output "rocketmq_consumer_group_id" {
  description = "The ID of the RocketMQ consumer group"
  value       = alicloud_rocketmq_consumer_group.this.consumer_group_id
}

# MSE Cluster outputs
output "mse_cluster_id" {
  description = "The ID of the MSE cluster"
  value       = alicloud_mse_cluster.this.id
}

output "mse_cluster_alias_name" {
  description = "The alias name of the MSE cluster"
  value       = alicloud_mse_cluster.this.cluster_alias_name
}

output "nacos_url" {
  description = "The Nacos server URL"
  value       = "${alicloud_mse_cluster.this.cluster_alias_name}:8848"
}

# ECS Login Address
output "ecs_login_address" {
  description = "The ECS workbench login address for the deployed application"
  value       = format("https://ecs-workbench.aliyun.com/?from=ecs&instanceType=ecs&regionId=%s&instanceId=%s&resourceGroupId=", data.alicloud_regions.current.regions[0].id, alicloud_instance.this.id)
}