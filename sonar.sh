#!/bin/bash


     growpart /dev/nvme0n1 4
     lvextend -L +16G /dev/RootVG/rootVol
     lvextend -L +7G /dev/mapper/RootVG-homeVol
     lvextend -L +7G /dev/mapper/RootVG-varVol
     xfs_growfs /
     xfs_growfs /var
     xfs_growfs /home 
    
     

dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

docker run -d --name sonarqube \
  -p 9000:9000 \
  sonarqube:community
