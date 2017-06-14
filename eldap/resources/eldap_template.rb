# This file is responsable for mapping eldap_template resource.
# It's like the template resource, but it works with the LDAP results.
resource_name :eldap_template

# LDAP server information
property :name                       , String             , name_property: true
property :mode                       , [String, Integer]  , default: '0000'
property :owner                      , [String, Integer]  , default: 'nobody'
property :group                      , [String, Integer]  , default: 'nobody'
property :path                       , String             , default: 'directory_not_specified'
property :source                     , [String, Array]    , default: 'template_not_specified'
property :variables                  , Hash               , default: {}

#LDAP Configuration
action :create do
   results = { :ldap => Eldap::Search.get_result_from(new_resource.name)}
   template new_resource.name do
     mode      new_resource.mode
     owner     new_resource.owner
     group     new_resource.group
     path      new_resource.path
     source    new_resource.source
     variables new_resource.variables.update(results)
   end
end

default_action :create
