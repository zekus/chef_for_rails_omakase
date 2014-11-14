# We disallow password connections via SSH
ruby_block 'disable password-based ssh logins' do
  block do
    file = Chef::Util::FileEdit.new('/etc/ssh/sshd_config')
    file.insert_line_if_no_match 'PasswordAuthentication no', 'PasswordAuthentication no'
    file.write_file
  end
end

##
## Simple iptables configuration for the basics:
##

# 1. By default, all incoming traffic is blocked
simple_iptables_policy 'INPUT' do
  policy 'DROP'
end

# 2. Both http and https traffic is allowed
simple_iptables_rule 'http' do
  rule [ '--proto tcp --dport 80',
         '--proto tcp --dport 443' ]
  jump 'ACCEPT'
end

# 3. localhost interface is permitted
simple_iptables_rule 'system' do
  rule '-i lo'
  jump 'ACCEPT'
end

# 4. Already established connections are maintained
simple_iptables_rule 'system' do
  rule '-m conntrack --ctstate ESTABLISHED,RELATED'
  jump 'ACCEPT'
end

# 5. Ping is handy
simple_iptables_rule 'system' do
  rule '-p icmp'
  jump 'ACCEPT'
end

# 6. And last but not least, we allow SSH at out specific port
simple_iptables_rule 'system' do
  rule '-p tcp --dport ssh'
  jump 'ACCEPT'
end
