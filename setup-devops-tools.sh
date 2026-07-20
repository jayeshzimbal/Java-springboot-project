#!/bin/bash

set -e

echo "================================="
echo "Updating System"
echo "================================="

sudo yum update -y || sudo dnf update -y


echo "================================="
echo "Installing Basic Tools"
echo "================================="

sudo yum install -y \
git \
curl \
wget \
unzip \
zip \
jq \
tree \
vim \
nano \
tar \
gzip \
which \
java-17-amazon-corretto-devel || \
sudo dnf install -y \
git \
curl \
wget \
unzip \
zip \
jq \
tree \
vim \
nano \
tar \
gzip \
which \
java-17-amazon-corretto-devel


echo "================================="
echo "Installing Docker"
echo "================================="

sudo yum install docker -y || sudo dnf install docker -y

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker ec2-user


echo "================================="
echo "Installing Docker Compose"
echo "================================="

sudo curl -L \
https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
-o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose


echo "================================="
echo "Installing AWS CLI"
echo "================================="

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o awscliv2.zip

unzip -o awscliv2.zip

sudo ./aws/install

rm -rf aws awscliv2.zip


echo "================================="
echo "Installing kubectl"
echo "================================="

curl -LO \
"https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl

sudo mv kubectl /usr/local/bin/


echo "================================="
echo "Installing eksctl"
echo "================================="

ARCH=amd64

curl --silent --location \
"https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_${ARCH}.tar.gz" \
| tar xz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin/


echo "================================="
echo "Installing Terraform"
echo "================================="

sudo yum install -y yum-utils || sudo dnf install -y yum-utils

sudo yum-config-manager \
--add-repo \
https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo || true

sudo dnf install terraform -y || sudo yum install terraform -y


echo "================================="
echo "Installing Helm"
echo "================================="

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash


echo "================================="
echo "Installing Jenkins"
echo "================================="

sudo wget \
-O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo


sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key


sudo yum install jenkins -y || sudo dnf install jenkins -y


sudo systemctl enable jenkins
sudo systemctl start jenkins


echo "================================="
echo "Versions"
echo "================================="

git --version
java -version
docker --version
docker-compose --version
aws --version
kubectl version --client
eksctl version
terraform version
helm version
jenkins --version


echo "================================="
echo "SETUP COMPLETED"
echo "Logout and login again for docker permission"
echo "================================="
