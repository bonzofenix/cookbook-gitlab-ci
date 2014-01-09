Gitlab Ci runner cookbook
=========================

This is an opensource cookbook for [Gitlab Ci](https://github.com/gitlabhq/gitlab-ci-runner)

The propose of this cookbook is to deploy 1 runner that integrates with a Gitlab Ci installation.

Requirements
============

- Running instance of Gitlab Ci. ([cookbook here](https://github.com/bonzofenix/cookbook-gitlab-ci))
- Running instance of Gitlab. ([cookbook here](https://github.com/ogom/cookbook-gitlab)) 


### Vagrant plugins

- vagrant-berkshelf
- vagrant-omnibus
- vagrant-aws

Installation
============

### Vagrant

#### VirtualBox

```bash
$ gem install berkshelf
$ vagrant plugin install vagrant-berkshelf
$ vagrant plugin install vagrant-omnibus
$ git clone git://github.com/bonzofenix/cookbook-gitlab-ci ./gitlab-ci-runner-deployment
$ cd ./gitlab-ci-runner-deployment/
$ vagrant up
```

#### Amazon Web Services

Create instance.

```bash
$ gem install berkshelf
$ vagrant plugin install vagrant-berkshelf
$ vagrant plugin install vagrant-omnibus
$ vagrant plugin install vagrant-aws
$ vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
$ git clone git://github.com/bonzofenix/cookbook-gitlab-ci ./gitlab-ci-runner-deployment
$ cd ./gitlab-ci-runner-deployment/
$ cp ./example/Vagrantfile_aws ./Vagrantfile
# Edit Vagrant file now!
$ vagrant up --provider=aws
```

Usage
=====

Example of node config.

```json
{
    "authorization": {
        "sudo": {
            "users": [
                "ubuntu",
                "gitlab_ci_runner",
                "vagrant"
            ],
            "passwordless": true
        }
    },
    "gitlab_ci_runner": {
        "gitlab_ci_url": "http://ec2-184-72-91-134.compute-1.amazonaws.com:9292",
        "gitlab_host": "ec2-54-204-141-109.compute-1.amazonaws.com",
        "gitlab_ci_token": "672ed80b57574b5b051a"
    },
    "rbenv": {
        "group_users": [
            "gitlab_ci_runner"
        ]
    },
    "run_list": [
        "gitlab-ci-runner::initial",
        "gitlab-ci-runner::default"
    ]
}
```


Licence
=======

- Mit
