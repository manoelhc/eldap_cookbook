# This file is responsable for mapping eldap_dump_results_from resource
# This resource prints out the results of a search.

resource_name :eldap_dump_results_from

# LDAP server information
property :name        , String,  name_property: true

#LDAP Configuration
action :create do
  results = Eldap::Search.get_result_from(name)
  Chef::Log.warn " Dump contents of #{name} search: #{results.inspect}"
end

default_action :create
