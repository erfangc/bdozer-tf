variable "vpc" {
  type = object({})
}

variable "aws_lb_listener_arn" {
  type = string
}

variable "container_port" {
  type        = number
  default     = 8080
  description = "The port that the LB target group will forward to on the containers, this is the main port your server listens on"
}

variable "cluster_id" {
  type    = string
  default = "my-ecs"
}

variable "service_name" {
  type = string
}

variable "desired_count" {
  type       = number
  defdefault = 1
}
