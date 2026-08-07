variable "application_name" {
  description = "Application name."
  type        = string
}

variable "instance_count" {
  description = "Number of resources to create."
  type        = number
  default     = 3

  validation {
    condition     = var.instance_count > 0
    error_message = "Instance count must be greater than zero."
  }
}