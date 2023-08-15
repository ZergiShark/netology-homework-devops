``terraform --version`` :
![screenshot](/screenshots/terraform_version.png)
# Задание 1

```
root@ter-homework:~/homework/ter-homeworks/01/src# cat .gitignore
# Local .terraform directories and files
**/.terraform/*
.terraform*

# .tfstate files
*.tfstate
*.tfstate.*

# own secret vars store.
personal.auto.tfvars
```
Из файла видно, что файл с variables(переменными) будет хранится в personal.auto.tfvars

# Задание 2

* Выполните код проекта. Найдите в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.

```
"result": "vEpc0uVIZkyqr7ZU"
```
* Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла **main.tf**. Выполните команду `terraform validate`. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.
```
root@ter-homework:~/homework/ter-homeworks/01/src# terraform validate
╷
│ Error: Missing name for resource
│
│   on main.tf line 24, in resource "docker_image":
│   24: resource "docker_image" {
│
│ All resource blocks must have 2 labels (type, name).
╵
╷
│ Error: Invalid resource name
│
│   on main.tf line 29, in resource "docker_container" "1nginx":
│   29: resource "docker_container" "1nginx" {
│
│ A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes.
```
в первом случае resource требует две переменные - докер образ и название образа
во втором была совершена ошибка в названии образа
также возникает ошибка:
```
root@ter-homework:~/homework/ter-homeworks/01/src# terraform validate
╷
│ Error: Reference to undeclared resource
│
│   on main.tf line 31, in resource "docker_container" "nginx":
│   31:   name  = "example_${random_password.random_string_FAKE.resulT}"
│
│ A managed resource "random_password" "random_string_FAKE" has not been declared in the root module.
```
Что значит неправильный вызов resources random_password - random_string_FAKE.resulT
Исправленный вариант:
```
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"
```
* Выполните код. В качестве ответа приложите вывод команды `docker ps`.
```
root@ter-homework:~/homework/ter-homeworks/01/src# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS              PORTS                  NAMES
5aec48449fcf   89da1fb6dcb9   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:8000->80/tcp   example_vEpc0uVIZkyqr7ZU
```
**Прошу пояснить, какая строчка в коде вызывает создание контейнера**

* Замените имя docker-контейнера в блоке кода на `hello_world`. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду `terraform apply -auto-approve`. Объясните своими словами, в чём может быть опасность применения ключа `-auto-approve`. В качестве ответа дополнительно приложите вывод команды `docker ps`.
Из мануала по terraform:
```
Options:

  -auto-approve          Skip interactive approval of plan before applying.
```
при вызове terraform apply, terraform сообщает об ошибках в конфигурации и обо всех изменениях, которые он совершает. Ключ -auto-approve позволяет игнорировать это. Здесь может возникнуть человеческий фактор. В результате этой ошибки мы получаем неработающий контейнер:
```
docker_container.nginx: Destruction complete after 1s
╷
│ Error: Unable to create container: Error response from daemon: Conflict. The container name "/example_vEpc0uVIZkyqr7ZU" is already in use by container "5aec48449fcf5c7b6efc6733e23595e242aa427a2968d634b8611a88a724cedf". You have to remove (or rename) that container to be able to reuse that name.
│
│   with docker_container.hello_world,
│   on main.tf line 29, in resource "docker_container" "hello_world":
│   29: resource "docker_container" "hello_world" {
│
root@ter-homework:~/homework/ter-homeworks/01/src# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
* Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**:
```
root@ter-homework:~/homework/ter-homeworks/01/src# cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.4.0",
  "serial": 10,
  "lineage": "5b8c2e79-832d-27c5-5563-a5c7e3279c06",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```

* Объясните, почему при этом не был удалён docker-образ **nginx:latest**. Ответ подкрепите выдержкой из документации [**провайдера docker**](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs).
Из документации:
```
- keep_locally - (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.
```
Из этой выдержки можно понять, что сохранение образа установлено по умолчанию. Для того, чтобы удалить образ необходимо использовать параметр keep_locally со значением true или false.