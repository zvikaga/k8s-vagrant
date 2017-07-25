sudo apt-get install -y virtualbox vagrant nfs-server
mkdir $HOME/k8s-vagrant && cd $HOME/k8s-vagrant
if [ ! -f Vagrantfile ]; then vagrant init fi
mv Vagrantfile.orig
git clone https://github.com/zvikaga/k8s-vagrant
vagrant up
