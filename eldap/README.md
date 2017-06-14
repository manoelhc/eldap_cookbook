# eldap

eldap cookbook helps you querying information from LDAP to work with your cookbook.


TODO: Create a better testing scripts
## Usage

Your need to create at least 3 "resources": eldap_connection, eldap (action :search) and eldap_execute. Note that the name of the resource will be used on eldap's conn_name attribute.

### eldap_connection resource

First of all, set your connection:

```
eldap_connection "ldap-example" do
  host ldap.mycompany.com
  port 389
  auth_method   'simple'
  auth_username 'cn=manager,dc=mycompany,dc=com'
  auth_password 'Password1'
end
```

Or set the attributes:

```
{"eldap" :
   "host" : "ldap.mycompany.com",
   "port" : 389,
   "auth": {
      "method" : "simple",
      "username" : "cn=manager,dc=mycompany,dc=com",
      "password" : "Password1"
   }
}
```

And use just set the connction name to use the default settings:

```
eldap_connection "ldap-example"
```

### eldap resource

#### action :search
Set the eldap (action :search) with a property name (this name will be used by other
resources like eldap_execute and eldap_dump_results_from):

* The 'conn_name' is the same name of the eldap_connection's resource name you set.
* The 'search' is the filter which you're looking for.
* The 'fields' are the properties you want to retrieve

```
eldap "search_username" do
  conn_name "ldap-example"
  basedn 'ou=users,dc=mycompany,dc=com'
  search [['cn', :eq, 'user*']]
  fields ['cn', 'homedirectory']
  action :search
end
```

#### For the future...
Include more actions like :create, :delete, :update

### eldap_execute resource

This is the way you iterate through the results of the LDAP search.

* NOTE: Use the same eldap resource name in order to get the results from that search.

```
eldap_execute "search_username" do |result|
  execute result['cn'] do
    command "echo '#{result.inspect}'"
  end
end
```

### eldap_template resource

This is a template-like resource, but it contains the LDAP search results pre-populated.
the resource name must be the name of the eldap (action :search) resource. All the
results will be stored in @ldap variable. To print the details, use <%=@ldap.inspect %>

* NOTE: Use the same eldap resource name in order to get the results from that search.

```
eldap_template "search_username" do
  source "eldap.erb"
  path "/tmp/eldap"
  mode '0777'
  owner 'root'
  variables ({ extra_info: :simple_value })
end
```

### eldap_dump_results_from resource

As the name says, it prints the results of a search in Chef's output (Log.warn).

* NOTE: Use the same eldap resource name in order to get the results from that search.

```
eldap_dump_results_from "search-user"
```
