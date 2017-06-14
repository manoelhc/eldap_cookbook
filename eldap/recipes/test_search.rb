# This recipe runs a simple test in order to check if the search is going good.
Chef::Log.warn('This is a test recipe. Do not use it unless you\'re testing this cookbook!')

include_recipe 'eldap::test_install'

eldap_connection "ldap"

eldap "search-user" do
  conn_name "ldap"
  basedn 'ou=users,dc=vagrantup,dc=com'
  search [['cn', :eq, 'user*']]
  fields ['cn', 'homedirectory']
  action :search
end

eldap_execute "search-user" do |result|
  execute result['cn'] do
    command "echo '#{result.inspect}'"
  end
end

eldap_dump_results_from "search-user"

eldap_template "search-user" do
  source "eldap.erb"
  path "/tmp/eldap"
  mode '0777'
  owner 'root'
  variables ({ extra_info: :simple_value })
end
