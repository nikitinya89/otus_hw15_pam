# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.network "private_network", ip: "192.168.111.11", adapter: 2, netmask: "255.255.255.0", virtualbox__intnet: "mynet"
  config.vm.hostname = "pam"
  ssh_pub_key = File.readlines("../id_rsa.pub").first.strip
  config.vm.provision "shell", inline: <<-SHELL
    mkdir -p ~root/.ssh
    echo #{ssh_pub_key} >> ~vagrant/.ssh/authorized_keys
    echo #{ssh_pub_key} >> ~root/.ssh/authorized_keys
    echo "PasswordAuthentication yes" > /etc/ssh/sshd_config.d/01-sshd.conf
    #sudo sed -i 's/\#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    systemctl restart sshd
  SHELL
  config.vm.provision "shell", path: "homework.sh", name: "homework script"  
  config.vm.provision "shell", path: "install-docker.sh", name: "install docker"
  config.vm.provision "shell", path: "allow-docker.sh", name: "allow docker"
  config.vm.provider "virtiualbox" do |vb|
    vb.cpus = 1
    vb.memory = 1024
  end
end
