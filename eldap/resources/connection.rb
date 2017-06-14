# This file is responsable for mapping eldap_connection resource

resource_name :eldap_connection

# LDAP server information
property :name         , String,  name_property: true
property :host         , String,  default: node['eldap']['host']
property :port         , Integer, default: node['eldap']['port']
property :auth_method  , String,  default: node['eldap']['auth']['method']
property :auth_username, String,  default: node['eldap']['auth']['username']
property :auth_password, String,  default: node['eldap']['auth']['password']

#LDAP Configuration
action :create do
  conf_hash = {
    :host         => host,
    :port         => port,
    :auth         => {
        :method     => auth_method,
        :username   => auth_username,
        :password   => auth_password
    }
  }
  Eldap::Search.set_connection conf_hash, name
end

default_action :create
