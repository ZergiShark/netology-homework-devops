output "VMs" {
  value = {
    instance_name1 = yandex_compute_instance.platform1.name
    external_ip1 = yandex_compute_instance.platform1.network_interface.0.nat_ip_address
    instance_name2 = yandex_compute_instance.platform2.name
    external_ip2 = yandex_compute_instance.platform2.network_interface.0.nat_ip_address
  }
}