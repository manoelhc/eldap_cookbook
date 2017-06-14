name 'eldap'
maintainer 'Manoel Carvalho'
maintainer_email 'manoelhc@gmail.com'
license 'MIT'
description 'Cookbook which provides resources to perfom searches on LDAP'
long_description 'Cookbook which provides resources to perfom searches on LDAP'
version '0.1.1'

gem 'net-ldap', '= 0.16.0'

depends 'openldap', '~> 3.0.3'

source_url 'https://github.com/manoelhc/eldap_cookbook'        if respond_to?(:source_url)
issues_url 'https://github.com/manoelhc/eldap_cookbook/issues' if respond_to?(:issues_url)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
#

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
