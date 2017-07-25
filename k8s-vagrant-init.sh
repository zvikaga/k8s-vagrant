#!/usr/bin/env bash
sudo apt-get update -y
sudo apt-get install -y virtualbox vagrant nfs-server
if [ ! -f Vagrantfile ]; then 
  mkdir $HOME/k8s-vagrant && cd $HOME/k8s-vagrant
  vagrant init
  mv Vagrantfile Vagrantfile.orig 
  git clone https://github.com/zvikaga/k8s-vagrant k8s-vagrant
  vagrant up
EOJ
else
  echo "Vagrant already was initialized in this direcotry"
fi
