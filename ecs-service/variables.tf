variable "container_port" {
  description = "The port that the LB target group will forward to on the containers, this is the main port your server listens on"
  type = number
  default = 8080
}

variable "service_name" {
  description = "The name of the ECS service"
  type = string
}

variable "desired_count" {
  description = "The desired number of instances of containers to run"
  type = number
  default = 1
}

variable "service_common_configs" {
  description = "Common configurations for a ECS service grouped together into a single object"
  type = object({
    vpc_id = string
    vpc_cidr_block = string
    private_subnets = list(string)
    cluster_id = string
    aws_lb_listener_arn = string
  })
}
