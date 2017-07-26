#!/usr/bin/env bash

echo -e "\nInstalling Docker....\n"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common sshpass
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu   $(lsb_release -cs)  stable"
sudo apt-get update
sudo apt-get -y install docker-ce=17.03.1~ce-0~ubuntu-$(lsb_release -c | awk '{print $2}')
sudo /etc/init.d/docker restart

# Allow non-root user to run docker commands
#sudo groupadd docker
#sudo usermod -aG docker $USER


echo -e "\ninstalling Docekr Compose - Not required by K8S....\n"
export COMPOSE_VERSION=1.13.0
sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose"
sudo chmod +x /usr/bin/docker-compose
sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"


echo -e "\nInstalling Kubectl....\n"
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
source <(kubectl completion bash)
sudo echo "source <(kubectl completion bash)" >> ~/.bashrc


echo -e "\nInstalling kubelet and kubeadm....\n"
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm


echo -e "\nInitializing the K8S cluster for the first time....\n"
sudo kubeadm init –api-advertise-addresses=10.1.1.10


echo -e "\nConfiguring kubectl for the first time....\n"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


echo -e "\nK8S cluster is up and running.\n\n\
You may use kubectl commands to manage the cluster.\n
Kubectl uses tcp/6443 int order to connect to the apiserver(on the master)\n\n
Todo:\n
1) Deploy pods network using one of the plugins in https://kubernetes.io/docs/concepts/cluster-administration/addons/\n
   You may use: kubectl apply -f <add-on.yaml>
2) Deploy pods, services and other things using Kubernetes Documentation (https://kubernetes.io/docs/home/)\n"
