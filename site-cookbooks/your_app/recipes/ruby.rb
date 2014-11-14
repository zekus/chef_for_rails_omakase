# We install a global default Ruby version despite the fact that each app
# may specify it's own. By default we need "bundler" and "ruby-shadow".

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

node['ruby_versions'].each do |version|

  rbenv_ruby version do
    ruby_version version
    global true
  end

  node['ruby_gems'].each do |gem|
    rbenv_gem gem do
      ruby_version version
    end
  end

end
