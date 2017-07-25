# Size of the cluster created by Vagrant
num_instances=3

# Change basename of the VM
instance_name_prefix="k8s-node"

Vagrant.configure("2") do |config|
  # always use Vagrants insecure key
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", type: "nfs"
  config.vm.box = "bento/ubuntu-16.04"

  config.vm.provider :virtualbox do |v|
    # On VirtualBox, we don't have guest additions or a functional vboxsf
    # in CoreOS, so tell Vagrant that so it can be smarter.
    v.check_guest_additions = false
    v.memory = 2048
    v.cpus = 1
    v.functional_vboxsf     = false
    end

  # Set up each box
  (1..num_instances).each do |i|
    if i == 1
      vm_name = "k8s-master"
    else
      vm_name = "%s-%02d" % [instance_name_prefix, i-1]
    end

    config.vm.define vm_name do |host|
      host.vm.hostname = vm_name

      if i == 1
       host.vm.network :private_network, ip: "10.1.1.10"
      else
       host.vm.network :private_network, ip: "10.1.1.#{i+10}"
      end

      # Install packages on all nodes
      #host.vm.provision :shell, inline: "/vagrant/all-nodes-install-script.sh", :privileged => true      
      
      #if i == 1
        # Configure the master.
        #host.vm.provision :file, :source => "master-config.yaml", :destination => "/tmp/vagrantfile-user-data"
        #host.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true

        #host.vm.provision :shell, :inline => "echo '127.0.0.1\tlocalhost' > /etc/hosts", :privileged => true
        #host.vm.provision :shell, :inline => "mkdir -p /etc/kubernetes/manifests/", :privileged => true
      #else
        # Configure a node.
        #host.vm.provision :file, :source => "node-config.yaml", :destination => "/tmp/vagrantfile-user-data"
        #host.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true
      end
    end
end
