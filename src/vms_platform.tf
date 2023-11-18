variable "vm_web_family" {
  type = string
  default = "ubuntu-2004-lts"
  description = "ubuntu version"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform ID"
}

variable "vm_db_family" {
  type = string
  default = "ubuntu-2004-lts"
  description = "ubuntu version"
}

variable "vms_resources" {
  type        = map(map(number))
  default     = {
    vm_web_resources = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
    vm_db_resources = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}

variable "common_metadata" {
  description = "metadata for all vms"
  type        = map(string)
  default     = {
    serial-port-enable = "1"
    ssh-keys          = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDM1HSJ6rcwhLG4SyF1xVrzvgvVo4pYdrYVy514/nhsQ3V2zuMiPSxZ652y9F7SGX6tktoj/zDBJOECncef7vlJ5azBdGh7CniM7yRwdRFzcUQWj8eE0auLdo75DOZynG0PVyWnhoHw50raKx9bq4PZqDIhfg2WwGWqKHT+Bpcum40ecb3YzcqGV6T8waMvmgUAFZWA+n/iKbcB6HXK2qcvwReO7rMnHwsaUljxKuIFIm0GEbT4ODt56qKlZ4Kzuu0GXaPpwfkijLHtsuLJbFGyyZpV7U76xNG1g3Q30CG58Xa6OAAu4l4b2mjzZqAct39bd1D82KT9LiniqQGlnfO0qCRpiP3F2WFEUe822twB2JYow9bwjB7VZZHMdy0KLxa4O4lPy7W3Fw5iOKlpsjcPKuwJJf1dpvWWk+wDHhYgNHUXhynSLpZhDawX49aQmgn1mKQfRxGStUxFdsrHANMri1h6Np3g/eo5FUHIIPkaOxw6gpMKNdcwZLaAtMe5wBk= root@epd46htq9q1k4tni7le1"
  }
}


variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform ID"
}


variable "vm_web_name" {
  type = string
  default = "netology-develop-platform-web"
}

variable "vm_db_name" {
  type = string
  default = "netology-develop-platform-db"
}