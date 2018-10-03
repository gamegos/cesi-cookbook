# CeSI Cookbook

This cookbook installs and configures [CeSI](https://github.com/gamegos/cesi).

# Requirements

## Platforms

- Ubuntu 14.04+
- Centos 7+

## Chef

- Chef 12.14+

## Cookbooks

- poise-python
- poise-service

# Recipes

- **default** - installs and configures the cesi.

# Attributes

- `['cesi']['user']` - Run cesi with this user - Default value is 'cesi'
- `['cesi']['group']` - Run cesi with this group - Default value is 'cesi'
- `['cesi']['setup_path']` - Download CESI to this directory - Default value is '/opt/cesi'
- `['cesi']['version']` - Install this version of CeSI - Default value is '2.0'
- `['cesi']['conf']['database']` - Create sqlite database in this path - Default value is 'userinfo.db'
- `['cesi']['conf']['activity_log']` - File path for CeSI activity logs - Default value is 'activity_log'
- `['cesi']['conf']['host']` - Host of the cesi application - Default value is '0.0.0.0'.
- `['cesi']['conf']['port']` - Port of the cesi application - Default value is '5000'.
- `['cesi']['conf']['debug']` - Boolean - Activate debug mode of the cesi backend - Default value is 'False'
- `['cesi']['conf']['auto_reload']` - Boolean - Activate auto reload mode of the cesi backend - Default value is 'False'
- `['cesi']['conf']['admin_username']` - Set admin username - Default value is 'admin'
- `['cesi']['conf']['admin_password']` - Set password of admin user - Default value is 'admin'

- `['cesi']['conf']['nodes']` - Array - Define all nodes - Default value is https://github.com/gamegos/cesi-cookbook/blob/master/attributes/default.rb#L27
- `['cesi']['conf']['environments']` - Array - Define all environments - Default value is https://github.com/gamegos/cesi-cookbook/blob/master/attributes/default.rb#L22
- `['cesi']['supervisors_rolename']` - Instead of typing all node configurations, find all nodes on the chef server with rolename. 

