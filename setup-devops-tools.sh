#!/bin/bash

######### jenkins plugins ###########
# git
# pipeline
# docker pipeline
# ssh agent
# credentials binding
# workspace cleanup
# pipeline stage view
#####################################

set -e
set -x
set -o pipefail


echo "========================================"
echo " Updating System"
echo "========================================"

sudo dnf update -y


echo "========================================"
echo " Installing Git"
echo "========================================"

sudo dnf install -y git


echo "========================================"
echo " Installing Java 21"
echo "========================================"

sudo dnf install -y java-21-amazon-corretto-devel


echo "========================================"
echo " Configuring JAVA_HOME for Java 21"
echo "========================================"

JAVA_HOME_PATH=/usr/lib/jvm/java-21-amazon-corretto.x86_64

echo "export JAVA_HOME=$JAVA_HOME_PATH" | sudo tee /etc/profile.d/java21.sh
echo 'export PATH=$JAVA_HOME/bin:$PATH' | sudo tee -a /etc/profile.d/java21.sh

source /etc/profile.d/java21.sh


echo "========================================"
echo " Installing Maven"
echo "========================================"

sudo dnf install -y maven


echo "========================================"
echo " Installing Docker"
echo "========================================"

sudo dnf install -y docker


sudo systemctl enable docker
sudo systemctl start docker


echo "========================================"
echo " Installing Docker Compose v2"
echo "========================================"

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}

mkdir -p $DOCKER_CONFIG/cli-plugins


curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
-o $DOCKER_CONFIG/cli-plugins/docker-compose


chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose


echo "========================================"
echo " Installing Docker Buildx"
echo "========================================"


curl -SL https://github.com/docker/buildx/releases/latest/download/buildx-linux-amd64 \
-o $DOCKER_CONFIG/cli-plugins/docker-buildx


chmod +x $DOCKER_CONFIG/cli-plugins/docker-buildx


echo "========================================"
echo " Installing Jenkins"
echo "========================================"


sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo


sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key


sudo dnf install -y jenkins


sudo systemctl enable jenkins
sudo systemctl start jenkins



echo "========================================"
echo " Configuring Docker Access"
echo "========================================"


sudo usermod -aG docker ec2-user

sudo usermod -aG docker jenkins


sudo systemctl restart docker
sudo systemctl restart jenkins



echo "========================================"
echo " Versions"
echo "========================================"


echo "Git Version:"
git --version


echo "Java Version:"
java -version


echo "Maven Version:"
mvn -version


echo "Docker Version:"
docker --version


echo "Docker Compose Version:"
docker compose version


echo "Docker Buildx Version:"
docker buildx version



echo "========================================"
echo " Jenkins Initial Password"
echo "========================================"


sudo cat /var/lib/jenkins/secrets/initialAdminPassword



echo "========================================"
echo " Installation Complete"
echo "========================================"