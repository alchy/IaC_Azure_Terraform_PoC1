variable "tags" {
  default = {
    user      = "jindra"
    provision = "terraform"
  }
}

variable "rg_prefix" {
  description = "Prefix pro názvy resource groups"
  type        = string
  default     = "jn"
}

variable "rg_env" {
  description = "Kompozit pro název prostředí (DEV||PROD...)"
  type        = string
  default     = "tst1"
}

#
# variables from shell
#
variable "admin_username" {
  description = "Administrator username for the VM (must be set in shell)"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for the VM (must be set in shell)"
  type        = string
  sensitive   = true
}

