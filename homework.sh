#!/bin/bash

for i in otusadm otus; do useradd $i -m -s /bin/bash; echo "$i:Qwerty123" | chpasswd; done
groupadd -f admin
for i in vagrant root otusadm; do usermod -aG admin $i; done
cp /vagrant/login.sh /usr/local/bin/
chmod +x /usr/local/bin/login.sh
sed -i -e '1 s/^/auth required pam_exec.so debug \/usr\/local\/bin\/login.sh\n/;' /etc/pam.d/sshd
