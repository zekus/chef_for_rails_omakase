user_name = node['user']['name']
user_group = node['user']['group']

user_account user_name do
  password node['user']['password']
  manage_home true
  home "/home/#{user_name}"
  gid user_group
  shell '/bin/bash'
  ssh_keys node['user']['ssh_keys']
end

group 'sudo' do
  action :modify
  members user_name
  append true
end
