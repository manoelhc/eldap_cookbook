# The LDAP connection information. This will be used as default value
# for resources that don't have the property properly configured.

default['eldap']['host'] = 'localhost'
default['eldap']['port'] = 389
default['eldap']['auth']['method'] = 'simple'

# These are the the auth credentials: bind-dn (username) and password
default['eldap']['auth']['username'] = 'cn=admin,dc=vagrantup,dc=com'
default['eldap']['auth']['password'] = 'changeme'
