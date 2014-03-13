#
# Cookbook Name:: gitlab_ci
# Recipe:: nginx
#

gitlab_ci = node['gitlab_ci']


# 7. Nginx
## Installation
package "nginx" do
  action :install
end

## Site Configuration
path = platform_family?("rhel") ? "/etc/nginx/conf.d/gitlab_ci.conf" : "/etc/nginx/sites-available/gitlab_ci"
template path do
  source "nginx.erb"
  mode 0644
  variables({
    :path => gitlab_ci['path'],
    :host => gitlab_ci['host'],
    :port => gitlab_ci['port']
  })
end

if platform_family?("rhel")
  directory gitlab_ci['home'] do
    mode 0755
  end
else
  link "/etc/nginx/sites-enabled/gitlab_ci" do
    to "/etc/nginx/sites-available/gitlab_ci"
  end

  file "/etc/nginx/sites-enabled/default" do
    action :delete
  end
end

## Restart
service "nginx" do
  action :restart
end
