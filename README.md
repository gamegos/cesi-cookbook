# CeSI Cookbook

This cookbook installs and configures [CeSI](https://github.com/gamegos/cesi). We support 2.6+ versions of cesi.

# Requirements

## Platforms

- Ubuntu 14.04+
- Centos 8+
- Debian 7+

## Chef

- Chef 13+

## Cookbooks

- tar
- poise-python
- poise-service

# Usage

Here's a quick example of installing the CeSI.

```ruby
cesi_install '2.6.5'

cesi_config 'supervisor'

cesi_service 'cesi'
```

# Recipes

- **default** - installs the CeSI.

# Attributes

- `['cesi']['user']` - Run cesi with this user - Default value is `'cesi'`
- `['cesi']['group']` - Run cesi with this group - Default value is `'cesi'`
- `['cesi']['version']` - Install this version of CeSI - Default value is `'2.6.4'`
- `['cesi']['setup_path']` - Download CeSI to this directory - Default value is `'/opt/cesi'`
- `['cesi']['conf']['database_uri']` - Use this database uri for CeSI database operations - Default value is `'sqlite:///users.db'`
- `['cesi']['conf']['activity_log']` - File path for CeSI activity logs - Default value is `'activity_log'`
- `['cesi']['conf']['admin_username']` - Set admin username - Default value is `'admin'`
- `['cesi']['conf']['admin_password']` - Set password of admin user - Default value is `'admin'`
- `['cesi']['service']['name']` - Service name of the cesi application - Defaul values is `'cesi'`
- `['cesi']['service']['host']` - Host of the cesi application - Default value is `'0.0.0.0'`.
- `['cesi']['service']['port']` - Port of the cesi application - Default value is `5000`.
- `['cesi']['service']['debug']` - Boolean - Activate debug mode of the cesi backend - Default value is `false`
- `['cesi']['service']['auto_reload']` - Boolean - Activate auto reload mode of the cesi backend - Default value is `false`
- `['cesi']['supervisors']['rolename']` - Instead of typing all node configurations, find all nodes on the chef server with rolename. Default value is `'supervisor'`
- `['cesi']['supervisors']['cloud_ipaddress]` - Get ipaddress of the supervisor in cloud servers. Default value is `'local_ipv4'`

# Resources

### cesi_install

Install the CeSI.

#### Actions

- `:create`

#### Properties

- `user` - (is: String)
- `group` - (is: String)
- `setup_path` - (is: String)
- `release_url` - (is: String)

#### Examples

```ruby
cesi_install '2.6.2' do
  user 'cesi'
  group 'cesi'
  setup_path '/opt/cesi'
  release_url 'https://gitlab.example.com/gamegos/cesi/releases/download/v2.6.2/cesi-extended.tar.gz'
  action :create
end
```

### cesi_config

Define configurations of the CeSI.

#### Actions

- `:create`

#### Properties

property :supervisors_rolename, String, name_property: true

- `database_uri` - (is: String)
- `activity_log` - (is: String)
- `admin_username` - (is: String)
- `admin_password` - (is: String)
- `cloud_ipaddress` - (is: String)

#### Examples

```ruby
cesi_config 'supervisor' do
  supervisors_rolename 'supervisor'
  database_uri 'sqlite:////opt/cesi/2.6.2/users.db'
  activity_log '/opt/cesi/2.6.2/activity.log'
  admin_username 'admin'
  admin_password 'admin'
  cloud_ipaddress 'local_ipv4'
  action :create
end
```

### cesi_service

Creates Cesi service for your systems.

#### Actions

- `:create`

#### Properties

- `host` - (is: String)
- `port` - (is: String)
- `debug` - (is: Boolean)
- `auto_reload` - (is: Boolean)

#### Examples

```ruby
cesi_service 'cesi' do
  host '0.0.0.0'
  port 5000
  debug false
  auto_reload false
  action :create
end
```
