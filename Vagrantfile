# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.hostname = "cookbook-gitlab-ci-berkshelf"
  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  config.vm.network :private_network, ip: "33.33.33.11"

  config.vm.network "forwarded_port", guest: 80 , host:  9292

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

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"
  config.berkshelf.enabled = true

  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.json = {
       'postgresql' => {'password' => { 'postgres' => 'password' }},
      'authorization'=> {'sudo' => { 'users' => ['ubuntu', 'gitlab_ci', 'vagrant'],
                                     'passwordless' => true} },
                                      "apt" => {"compiletime" => true} ,
      'gitlab_ci' =>{
        'allow_gitlab_urls' => [
          'http://33.33.33.10',
          'https://gitlab.com'
        ]
      }
    }

    chef.run_list = [
      "gitlab-ci::initial",
      "gitlab-ci::default"
    ]
  end
end
