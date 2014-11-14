user_name = node['user']['name']
user_group = node['user']['group']

# This is a user folder for all the apps
directory "/home/#{user_name}/apps" do
  owner user_name
  group user_group
end

node['nginx']['virtual_hosts'].each do |virtual_host|
  root_folder = virtual_host['root_folder']

  # Creates the basic directory structure for the app so that nginx can run
  directory root_folder do
    owner user_name
    group user_group
  end

  %w(shared shared/config shared/log).each do |directory|
    directory "#{root_folder}/#{directory}" do
      owner user_name
      group user_group
    end
  end

  # We use a different template file depending on SSL
  template_file = if virtual_host['ssl_certificate_bundle_path'].nil?
    'nginx.conf.erb'
  else
    'nginx-ssl.conf.erb'
  end

  # Configure nginx virtual host
  template "#{node['nginx']['dir']}/sites-available/#{virtual_host['app_name']}" do
    source template_file
    owner user_name
    variables(
      app_name: virtual_host['app_name'],
      local_port: virtual_host['local_port'],
      server_names: virtual_host['server_names'].join(' '),
      root_folder: root_folder,
      ssl_certificate_bundle_path: virtual_host['ssl_certificate_bundle_path'],
      ssl_certificate_key_path: virtual_host['ssl_certificate_key_path']
    )
  end

  # Enable the in /etc/nginx/sites-enabled
  nginx_site virtual_host['app_name']

  # To finish, let's include a proper database.yml file ready to rock
  template "#{root_folder}/shared/config/database.yml" do
    source 'database.yml.erb'
    owner user_name
    variables(
      environment: virtual_host['environment'],
      username: node['postgresql']['users'][0]['username'],
      password: node['postgresql']['users'][0]['password']
    )
  end
end

# To make all the changes effective, let's force a reload
service 'nginx' do
  action :reload
end
