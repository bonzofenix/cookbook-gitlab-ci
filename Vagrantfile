# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.hostname = "cookbook-gitlab-ci-berkshelf"
  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  config.vm.network "forwarded_port", guest: 9292, host:  9292

  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  config.ssh.max_tries = 40
  config.ssh.timeout   = 120

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"
  config.berkshelf.enabled = true

  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.json = {
       'postgresql' => {'password' => { 'postgres' => 'password' }},
      'authorization'=> {'sudo' => { 'users' => ['gitlab_ci', 'vagrant'],
                                     'passwordless' => true} },
                                      "apt" => {"compiletime" => true} 
    }

    chef.run_list = [
      "gitlab-ci::initial",
      "gitlab-ci::default"
    ]
  end
end
