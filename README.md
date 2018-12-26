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

| Attribute                                        |        Default         | Description                                                                                |
| ------------------------------------------------ | :--------------------: | ------------------------------------------------------------------------------------------ |
| `node['cesi']['user']`                           |        `'cesi'`        | Run cesi with this user                                                                    |
| `node['cesi']['group']`                          |        `'cesi'`        | Run cesi with this group                                                                   |
| `node['cesi']['version']`                        |       `'2.6.5'`        | Install this version of CeSI                                                               |
| `node['cesi']['setup_path']`                     |     `'/opt/cesi'`      | Download CeSI to this directory                                                            |
| `node['cesi']['conf']['database_uri']`           | `'sqlite:///users.db'` | Use this database uri for CeSI database operations                                         |
| `node['cesi']['conf']['activity_log']`           |    `'activity_log'`    | File path for CeSI activity logs                                                           |
| `node['cesi']['conf']['admin_username']`         |       `'admin'`        | A cesi user with admin privileges                                                          |
| `node['cesi']['conf']['admin_password']`         |       `'admin'`        | The cesu user's password                                                                   |
| `node['cesi']['service']['name']`                |        `'cesi'`        | Service name of the cesi application                                                       |
| `node['cesi']['service']['host']`                |      `'0.0.0.0'`       | The host cesi is running on                                                                |
| `node['cesi']['service']['port']`                |         `5000`         | The port cesi is running on                                                                |
| `node['cesi']['service']['debug']`               |        `false`         | Activate debug mode of the cesi backend                                                    |
| `node['cesi']['service']['auto_reload']`         |        `false`         | Activate auto reload mode of the cesi backend                                              |
| `node['cesi']['supervisors']['rolename']`        |     `'supervisor'`     | Instead of typing all node configurations, find all nodes on the chef server with rolename |
| `node['cesi']['supervisors']['cloud_ipaddress']` |     `'local_ipv4'`     | Get ipaddress of the supervisor in cloud servers                                           |

# Resources

## cesi_install

This resource installs the CeSI.

#### Properties

| Property      |   Type    | Default Value | Description                     |
| ------------- | :-------: | :-----------: | ------------------------------- |
| `version`     | `String`  |   `'2.6.5'`   | The version of cesi             |
| `user`        | `String`  |   `'cesi'`    | The user of cesi                |
| `group`       | `Integer` |   `'cesi'`    | The group of cesi               |
| `setup_path`  | `String`  |   `'admin'`   | Download CeSI to this directory |
| `release_url` | `String`  |   `'admin'`   | Download CeSI with this url     |
| `action`      | `String`  |   `create`    | Valid action is `create`.       |

#### Examples

```ruby
cesi_install '2.6.5' do
  user 'cesi'
  group 'cesi'
  setup_path '/opt/cesi'
  release_url 'https://gitlab.example.com/gamegos/cesi/releases/v2.6.5/cesi-extended.tar.gz'
  action :create
end
```

## cesi_config

This resource defines configurations of the CeSI.

#### Properties

| Property               |   Type   |     Default Value      | Description                                      |
| ---------------------- | :------: | :--------------------: | ------------------------------------------------ |
| `supervisors_rolename` | `String` |     `'supervisor'`     | The supervisors rolename                         |
| `database_uri`         | `String` | `'sqlite:///users.db'` | The database uri for CeSI database               |
| `activity_log`         | `String` |    `'activity.log'`    | File path for CeSI activity logs                 |
| `admin_user`           | `String` |       `'admin'`        | A cesi user with admin privileges                |
| `admin_password`       | `String` |       `'admin'`        | The cesi user's password                         |
| `cloud_ipaddress`      | `String` |     `'local_ipv4'`     | Get ipaddress of the supervisor in cloud servers |
| `action`               | `String` |        `create`        | Valid action is `create`.                        |

#### Examples

```ruby
cesi_config 'supervisor' do
  supervisors_rolename 'supervisor'
  database_uri 'sqlite:////opt/cesi/2.6.5/users.db'
  activity_log '/opt/cesi/2.6.5/activity.log'
  admin_username 'admin'
  admin_password 'admin'
  cloud_ipaddress 'local_ipv4'
  action :create
end
```

## cesi_service

This resource creates the Cesi service for your systems.

#### Properties

| Property      |   Type    | Default Value | Description                                   |
| ------------- | :-------: | :-----------: | --------------------------------------------- |
| `host`        | `String`  |  `'0.0.0.0'`  | The host cesi is running on                   |
| `port`        | `Integer` |    `5000`     | The port cesi is running on                   |
| `debug`       | `Boolean` |    `false`    | Activate debug mode of the cesi backend       |
| `auto_reload` | `Boolean` |    `false`    | Activate auto reload mode of the cesi backend |
| `action`      | `String`  |   `create`    | Valid action is `create`.                     |

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
