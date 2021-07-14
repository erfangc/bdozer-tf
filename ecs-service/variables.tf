variable "container_port" {
  type        = number
  default     = 8080
  description = "The port that the LB target group will forward to on the containers, this is the main port your server listens on"
}

variable "service_name" {
  type = string
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "service_common_cfgs" {
  type = object({
    vpc_id              = string
    vpc_cidr_block      = string
    private_subnets     = list(string)
    cluster_id          = string
    aws_lb_listener_arn = string
  })
}
