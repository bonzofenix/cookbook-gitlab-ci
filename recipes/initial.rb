include_recipe "apt"
include_recipe "sudo"
include_recipe "build-essential"
include_recipe "git"

## Create user for Gitlab.
user node['gitlab_ci']['user'] do
  comment "GitLab Ci Runner"
  home node['gitlab_ci']['home']
  shell "/bin/bash"
  supports :manage_home => true
end
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

include_recipe "postgresql::server"

user node['gitlab_ci']['user'] do
  action :lock
end

