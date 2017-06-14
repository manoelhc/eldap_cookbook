# This recibe basically installs OpenLDAP and create some users in order to
# be used on test_search.

Chef::Log.warn('This is a test recipe. Do not use it unless you\'re testing this cookbook!')


# Using a dumb password for this (changeme hash)
node.override['openldap']['rootpw'] = '{SSHA}cHVAk1/jsUOYAJY/in5SmKSHbd4pdtU9'
include_recipe 'openldap'
package "openldap-clients"

# Create the new template to set up the environment
template 'test_basedn.ldif' do
  path '/tmp/test_basedn.ldif'
  not_if { ::File.exist?('/tmp/test_basedn.ldif') }
  notifies :run, 'bash[install-test_basedn]', :immediate
end

# It will be run just if the template is new. This prevents that it runs 2x
bash "install-test_basedn" do
  cwd '/tmp'
  code <<-EOH
  ldapadd -x -D '#{node['eldap']['auth']['username']}' -f 'test_basedn.ldif' -w '#{node['eldap']['auth']['password']}'
  EOH
  action :nothing
end

# Create the new template to add new group
template 'test_group.ldif' do
  path '/tmp/test_group.ldif'
  not_if { ::File.exist?('/tmp/test_group.ldif') }
  notifies :run, 'bash[install-test_group]', :immediate
end

# It will be run just if the group template is new. This prevents that it runs 2x
bash "install-test_group" do
  cwd '/tmp'
  code <<-EOH
  ldapadd -x -D '#{node['eldap']['auth']['username']}' -f 'test_group.ldif' -w '#{node['eldap']['auth']['password']}'
  EOH
  action :nothing
end

# Sample users
users = ["user1", "user2", "user3"]

# Create new users
users.each do |username|

  # Create the new template to add a new sample user
  template "test_user_#{username}.ldif" do
    source "test_user.ldif.erb"
    path "/tmp/test_user_#{username}.ldif"
    variables user: username
    not_if { ::File.exist?("/tmp/test_user_#{username}.ldif") }
    notifies :run, "bash[install-#{username}-user]", :immediate
  end

  # It will be run just if the user template is new. This prevents that it runs 2x
  bash "install-#{username}-user" do
    cwd '/tmp'
    code <<-EOH
    ldapadd -x -D '#{node['eldap']['auth']['username']}' -f 'test_user_#{username}.ldif' -w '#{node['eldap']['auth']['password']}'
    EOH
    action :nothing
  end
end
