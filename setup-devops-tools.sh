#!/bin/bash

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
echo " Installing Maven"
echo "========================================"
sudo dnf install -y maven

echo "========================================"
echo " Installing Docker"
echo "========================================"
sudo dnf install -y docker

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins || true

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
echo " Versions"
echo "========================================"

git --version
java -version
mvn -version
docker --version
docker compose version
docker buildx version

echo "========================================"
echo " Installation Complete"
echo "========================================"

echo "Jenkins Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword