rbenv_ruby '2.0.0-p247' do
  global true
end

rbenv_gem 'bundler' do
  ruby_version '2.0.0-p247'
end
rbenv_gem 'whenever' do
  ruby_version '2.0.0-p247'
end


execute "sudo adduser --disabled-login --gecos 'GitLab CI' gitlab_ci" do
  not_if 'id -u gitlab_ci'
end

cookbook_file '/tmp/initial.sql' do
  source 'initial.sql'
  mode "0644"
  action :create_if_missing
end

execute 'sudo -u postgres psql -f /tmp/initial.sql'

git node['gitlab_ci']['app_home'] do
  repository node['gitlab_ci']['git']['url']
  reference node['gitlab_ci']['git']['branch']
  action :checkout
  user 'gitlab_ci'
end

template "#{node['gitlab_ci']['app_home']}/config/application.yml" do
  source "application.yml.example"
  mode "0644"
  variables({ })
  user 'gitlab_ci'
end

template "#{node['gitlab_ci']['app_home']}/config/database.yml" do
  source "database.yml.erb"
  mode "0644"
  variables({ })
  user 'gitlab_ci'
end

template "#{node['gitlab_ci']['app_home']}/config/puma.rb" do
  source "puma.rb.example"
  mode "0644"
  variables({ })
  user 'gitlab_ci'
end

bash 'setup_sokets_and_pids' do
  cwd node['gitlab_ci']['app_home']
  code <<-EOH
          sudo -u gitlab_ci -H mkdir -p tmp/sockets/
          sudo chmod -R u+rwX  tmp/sockets/
          sudo -u gitlab_ci -H mkdir -p tmp/pids/
          sudo chmod -R u+rwX  tmp/pids/
         EOH
   not_if { ::File.exists?('tmp/sockets') }
   user 'gitlab_ci'
end

execute "sudo apt-get -y install libpq-dev"



bash 'setup_gitlab_ci_daemon' do
  cwd node['gitlab_ci']['app_home']
  code <<-EOH
          sudo env ARCHFLAGS="-arch i386" gem install pg -v 0.15.1 --no-document
          sudo -u gitlab_ci -H bundle install --without development test mysql --deployment
          sudo cp /home/gitlab_ci/gitlab-ci/lib/support/init.d/gitlab_ci /etc/init.d/gitlab_ci
          sudo chmod +x /etc/init.d/gitlab_ci
          sudo update-rc.d gitlab_ci defaults 21
         EOH
   user 'gitlab_ci'
end

execute "sudo rbenv rehash"
execute 'sudo -u gitlab_ci -H bundle exec rake db:setup RAILS_ENV=production'
execute 'sudo -u gitlab_ci -H bundle exec whenever -w RAILS_ENV=production'
execute 'sudo service gitlab_ci start'

# bash 'setup_nginx' do
  # code <<-EOH
    # sudo apt-get install nginx
    # sudo cp /home/gitlab_ci/gitlab-ci/lib/support/nginx/gitlab_ci /etc/nginx/sites-available/gitlab_ci
    # sudo ln -s /etc/nginx/sites-available/gitlab_ci /etc/nginx/sites-enabled/gitlab_ci
         # EOH
   # not_if { 'which nginx' }
   # user 'gitlab_ci'
# end
