include_recipe "apt"
include_recipe "sudo"
include_recipe "build-essential"
include_recipe "git"
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
include_recipe "postgresql::server"




