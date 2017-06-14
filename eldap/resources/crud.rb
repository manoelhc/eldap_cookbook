# This file is responsable for mapping eldap resource
resource_name :eldap

# LDAP server information
property :name        , String,  name_property: true
property :conn_name   , String,  default: 'default'
property :basedn      , String,  default: ''
property :properties  , Hash,    default: {}
property :search      , Array,   default: []
property :fields      , Array,   default: []

#LDAP Configuration
action :search do
  Eldap::Search.search conn_name, name, basedn, search, fields
end

default_action :search
