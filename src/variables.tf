###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDM1HSJ6rcwhLG4SyF1xVrzvgvVo4pYdrYVy514/nhsQ3V2zuMiPSxZ652y9F7SGX6tktoj/zDBJOECncef7vlJ5azBdGh7CniM7yRwdRFzcUQWj8eE0auLdo75DOZynG0PVyWnhoHw50raKx9bq4PZqDIhfg2WwGWqKHT+Bpcum40ecb3YzcqGV6T8waMvmgUAFZWA+n/iKbcB6HXK2qcvwReO7rMnHwsaUljxKuIFIm0GEbT4ODt56qKlZ4Kzuu0GXaPpwfkijLHtsuLJbFGyyZpV7U76xNG1g3Q30CG58Xa6OAAu4l4b2mjzZqAct39bd1D82KT9LiniqQGlnfO0qCRpiP3F2WFEUe822twB2JYow9bwjB7VZZHMdy0KLxa4O4lPy7W3Fw5iOKlpsjcPKuwJJf1dpvWWk+wDHhYgNHUXhynSLpZhDawX49aQmgn1mKQfRxGStUxFdsrHANMri1h6Np3g/eo5FUHIIPkaOxw6gpMKNdcwZLaAtMe5wBk= root@epd46htq9q1k4tni7le1"
  description = "ssh-keygen -t ed25519"
}

variable "vm_web_family" {
  type = string
  default = "ubuntu-2004-lts"
}

variable "vm_web_name" {
  type = string
  default = "netology-develop-platform-web"
}

variable "vm_web_platform_id" {
  type = string
  default = "standard-v2"
}

variable "vm_web_cores" {
  type = number
  default = 2
}

variable "vm_web_memory" {
  type = number
  default = 1
}

variable "vm_web_core_fraction" {
  type = number
  default = 5
}