output "web_url" {
  description = "The URL of the web application"
  value       = module.monitoring_solution.web_url
}

output "ecs_login_address" {
  description = "The ECS workbench login address for the deployed application"
  value       = module.monitoring_solution.ecs_login_address
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.monitoring_solution.vpc_id
}

output "ecs_instance_id" {
  description = "The ID of the ECS instance"
  value       = module.monitoring_solution.ecs_instance_id
}

output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = module.monitoring_solution.rds_instance_id
}

output "redis_instance_id" {
  description = "The ID of the Redis instance"
  value       = module.monitoring_solution.redis_instance_id
}

output "rocketmq_instance_id" {
  description = "The ID of the RocketMQ instance"
  value       = module.monitoring_solution.rocketmq_instance_id
}

output "mse_cluster_id" {
  description = "The ID of the MSE cluster"
  value       = module.monitoring_solution.mse_cluster_id
}

output "nacos_url" {
  description = "The Nacos server URL"
  value       = module.monitoring_solution.nacos_url
}