# Installs some basic packages
package 'htop'
package 'nodejs'
package 'imagemagick'
package 'libmagick++-dev'
package 'git-core'
package 'ssl-cert'

# Let's create some swapping space
swap_file '/mnt/swap' do
  size 1024
end

# Configure the proper timezone
execute 'configure timezone' do
  command 'echo "Europe/Madrid" > /etc/timezone; dpkg-reconfigure --frontend noninteractive tzdata'
end
