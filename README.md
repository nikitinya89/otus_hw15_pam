# Otus Homework 15. Авторизация и аутентификация
### Цель домашнего задания
Научиться создавать пользователей и добавлять им ограничения
### Описание домашнего задания
- Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников
- Дать конкретному пользователю права работать с докером и возможность рестартить докер сервис*
## Выполнение
Домашнее задание выполняется на виртуальной машине с ОС *Ubuntu 22.04*, созданной с помощью *Vagrant*. Все действия выполняется с помощью bash скриптов, запущенных с помощью *Vagrant Provision*.
### Запретить всем пользователям, кроме группы admin логин в выходные
Скрипт **homework.sh** выполняет следующие действия:
- создает пользователей *otus* и *otusadm* и задает им пароль
- создает группу *admin*, если она не существует, и добавляет в нее пользователей *vagrant*, *root* и *otusadm*
- копирует скрипт *login.sh* в каталог */usr/local/bin/*
- добавляет pam-модуль *pam_exec*, использующий скрипт *login.sh*, в */etc/pam.d/sshd*

Скрипте **login.sh** выполняет проверкау текущего дня недели. В том случае, если это Суббота или Воскресенье, выполняется проверка пренадлежности пользователи к группе *admin*. В противном случае скрипт завершается с кодом 1, что препятствует успешной авторизации пользователя.

Убедимся в правильной работе скрипта. Для начала изменим дату, чтобы система думала, что сегодня Воскресенье:
```bash
root@pam:~# timedatectl set-ntp 0
root@pam:~# date 060912002024.00
Sun Jun  9 12:00:00 UTC 2024
```
При попытке авторизации под пользователем *otus* получаем ошибку:
```bash
ssh otus@192.168.111.11
otus@192.168.111.11's password:
Permission denied, please try again.
```
При этом пользователь *otusadm*, входящий в группу *admin* успешно входит в систему:
```bash
ssh otusadm@192.168.111.11
otusadm@192.168.111.11's password:
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-97-generic x86_64)
```
### Дать конкретному пользователю права работать с докером и возможность рестартить докер сервис
Установим *Docker* с помощью скрипта **docker-install.sh**. Так что же импортирует образ *hello-world* для осуществления проверки.  

Для выполнения задания запускается скрипт **allow-docker.sh**.  

Для того, что пользователь *otus*, не обладающий root правами мог работать с Docker, добавим его в группу *docker*.

```bash
sudo gpasswd -a otus docker
```
Проверим, запустив контейнер *hello-world*:
```bash
otus@pam:~$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```
Чтобы предоставить пользователю возможность перезагружать сервис, добавим строчку `otus ALL=(ALL) NOPASSWD: /bin/systemctl restart docker.service
` в файл */etc/sudoers*, используя утилиту *visudo*. Теперь пользователь сможет выполнить команду `systemctl restart docker.service`, используя *sudo* без ввода пароля:
```bash
otus@pam:~$ sudo systemctl restart docker.service
otus@pam:~$
otus@pam:~$ systemctl status docker.service
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2024-06-06 18:51:08 UTC; 5s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 4490 (dockerd)
      Tasks: 9
     Memory: 28.0M
        CPU: 416ms
     CGroup: /system.slice/docker.service
             └─4490 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```
