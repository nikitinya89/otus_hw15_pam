# Otus Homework 15. Авторизация и аутентификация
### Цель домашнего задания
Научиться создавать пользователей и добавлять им ограничения
### Описание домашнего задания
- Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников
- Дать конкретному пользователю права работать с докером и возможность рестартить докер сервис*
## Выполнение



```bash
timedatectl set-ntp 0
root@pam:~# date 060912002024.00
Sun Jun  9 12:00:00 UTC 2024
```

```bash
ssh otus@192.168.111.11
otus@192.168.111.11's password:
Permission denied, please try again.
```

```bash
ssh otusadm@192.168.111.11
otusadm@192.168.111.11's password:
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-97-generic x86_64)
```



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


```bash
otus@pam:~$ sudo systemctl restart docker.service
otus@pam:~$
otus@pam:~$ systemctl status docker.service
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2024-06-06 18:51:08 UTC; 6s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 4490 (dockerd)
      Tasks: 9
     Memory: 28.0M
        CPU: 416ms
     CGroup: /system.slice/docker.service
             └─4490 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```
