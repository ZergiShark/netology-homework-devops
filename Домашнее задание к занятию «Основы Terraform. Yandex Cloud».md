## Задание 1

4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
```
resource "yandex_compute_instance" "platform" {
  name        = "netology-develop-platform-web"
  platform_id = "standart-v4"
  resources {
    cores         = 1
    memory        = 1
    core_fraction = 5
  }
```
Ошибка в слове standard. В документации указано, что самая новая версия платформы - это   
v3, но для использования производительности на уровне 5% доступны только Intel 
Broadwell (standard-v1) и Intel Cascade Lake (standard-v2). Также, минимальное 
количество ядер для использования - 2.  
5. параметр preemptible обычно относится к возможности использования прерываемых (preemptible) виртуальных машин или экземпляров. Прерываемые экземпляры предоставляют временные ресурсы по более низкой цене, но с одним важным ограничением: они могут быть прерваны (выключены) по требованию облачного провайдера без предварительного уведомления. Параметр core_fraction=5 указывает на то, что требуется выделить только 5% от общего количества ядер процессора для данного экземпляра. Это означает, что экземпляр будет использовать только небольшую часть вычислительных ресурсов процессора, оставляя остальные ресурсы доступными для других задач или экземпляров. Польза о данных знаниях очевидна - можно сэкономить деньги.
![screenshot](/screenshots/terraform_vm.png)
![screenshot](/screenshots/terraform_ssh.png)
## Задание 2

### main.tf:
```
data "yandex_compute_image" "ubuntu" {
  family = "var.vm_web_family"
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
```
### variables.tf:
```
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
```


![screenshot](/screenshots/terraform_plan.png)

## Задание 3

### vms_platform.tf:

```
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
  description = "Resources for all vms"
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
```
### main.tf:

```
data "yandex_compute_image" "ubuntu2" {
  family = var.vm_db_family
}
resource "yandex_compute_instance" "platform2" {
  name        = var.vm_db_name
  platform_id = var.vm_db_platform_id
  metadata    = var.common_metadata
  resources {
    cores         = var.vms_resources.vm_db_resources.cores
    memory        = var.vms_resources.vm_db_resources.memory
    core_fraction = var.vms_resources.vm_db_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
```

### Виртуальные машины:
![screenshot](/screenshots/terraform_vms.png)
### Задание 4
### outputs.tf:
```
output "VMs" {
  value = {
    instance_name1 = yandex_compute_instance.platform1.name
    external_ip1 = yandex_compute_instance.platform1.network_interface.0.nat_ip_address
    instance_name2 = yandex_compute_instance.platform2.name
    external_ip2 = yandex_compute_instance.platform2.network_interface.0.nat_ip_address
  }
}
```
![screenshot](/screenshots/terraform_output.png)

## Задание 5

### locals.tf:
```
locals {
    project = "netology-develop-platform"
    env_web = "web"
    env_db = "db"
    vm_web_name = "${local.project}-${local.env_web}"
    vm_db_name = "${local.project}-${local.env_db}"
}
```
Внёс изменения в названиях ВМ в main.tf:
```
...
resource "yandex_compute_instance" "platform1" {
  name =  local.vm_web_name
  platform_id = var.vm_web_platform_id
...
resource "yandex_compute_instance" "platform2" {
  name        = local.vm_db_name
  platform_id = var.vm_db_platform_id
```

## Задание 6

1. Переменные ресурсов для виртуальных машин:
```
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
```
main.tf:
```
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform1" {
  name =  local.vm_web_name
  platform_id = var.vm_web_platform_id
  metadata = var.common_metadata
  resources {
    cores         = var.vms_resources.vm_web_resources.cores
    memory        = var.vms_resources.vm_web_resources.memory
    core_fraction = var.vms_resources.vm_web_resources.core_fraction
  }

 boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu.image_id
      }
    }
   scheduling_policy {
      preemptible = true
    }
    network_interface {
      subnet_id = yandex_vpc_subnet.develop.id
      nat       = true
   }
}


data "yandex_compute_image" "ubuntu2" {
  family = var.vm_db_family
}
resource "yandex_compute_instance" "platform2" {
  name        = local.vm_db_name
  platform_id = var.vm_db_platform_id
  metadata    = var.common_metadata
  resources {
    cores         = var.vms_resources.vm_db_resources.cores
    memory        = var.vms_resources.vm_db_resources.memory
    core_fraction = var.vms_resources.vm_db_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

```
2. metadata:
```
variable "common_metadata" {
  description = "metadata for all vms"
  type        = map(string)
  default     = {
    serial-port-enable = "1"
    ssh-keys          = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDM1HSJ6rcwhLG4SyF1xVrzvgvVo4pYdrYVy514/nhsQ3V2zuMiPSxZ652y9F7SGX6tktoj/zDBJOECncef7vlJ5azBdGh7CniM7yRwdRFzcUQWj8eE0auLdo75DOZynG0PVyWnhoHw50raKx9bq4PZqDIhfg2WwGWqKHT+Bpcum40ecb3YzcqGV6T8waMvmgUAFZWA+n/iKbcB6HXK2qcvwReO7rMnHwsaUljxKuIFIm0GEbT4ODt56qKlZ4Kzuu0GXaPpwfkijLHtsuLJbFGyyZpV7U76xNG1g3Q30CG58Xa6OAAu4l4b2mjzZqAct39bd1D82KT9LiniqQGlnfO0qCRpiP3F2WFEUe822twB2JYow9bwjB7VZZHMdy0KLxa4O4lPy7W3Fw5iOKlpsjcPKuwJJf1dpvWWk+wDHhYgNHUXhynSLpZhDawX49aQmgn1mKQfRxGStUxFdsrHANMri1h6Np3g/eo5FUHIIPkaOxw6gpMKNdcwZLaAtMe5wBk= root@epd46htq9q1k4tni7le1"
  }
```
3. Удалил неиспользуемые переменные
4. Terraform plan:
```
root@epd46htq9q1k4tni7le1:~/ter/02/src# terraform plan
yandex_vpc_network.develop: Refreshing state... [id=enpcpnkpb7kob0quaih2]
data.yandex_compute_image.ubuntu2: Reading...
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu2: Read complete after 1s [id=fd853sqaosrb2anl1uve]
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd853sqaosrb2anl1uve]
yandex_vpc_subnet.develop: Refreshing state... [id=e9bvo4o1at05jkuhs9co]
yandex_compute_instance.platform2: Refreshing state... [id=fhm2gbrcgas2vijnb9ot]
yandex_compute_instance.platform1: Refreshing state... [id=fhm3ekli2dp9e901ij2b]

No changes. Your infrastructure matches the configuration.
```