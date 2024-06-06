#!/bin/bash
sudo gpasswd -a otus docker
echo 'otus ALL=(ALL) NOPASSWD: /bin/systemctl restart docker.service' | sudo EDITOR='tee -a' visudo