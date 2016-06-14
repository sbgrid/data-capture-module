# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # pick your favorite (or already downloaded) c6 box
  config.vm.box = "geerlingguy/centos6"

  config.vm.box_check_update = false

  config.vm.network "forwarded_port", guest: 80, host: 8080
  # might be suboptimal to do sshd work in vagrant

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./", "/usr/local/dcm"

  # provision with ansible
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/dcm.yml"
  end  
end
