default['cesi']['user'] = 'cesi'
default['cesi']['group'] = 'cesi'
default['cesi']['version'] = '2.6.7'
default['cesi']['setup_path'] = '/opt/cesi'

default['cesi']['conf'] = {
  'admin_username': 'admin',
  'admin_password': 'admin',
  'database_uri': 'sqlite:///users.db',
  'activity_log': 'activity.log',
}

default['cesi']['supervisors'] = {
  'rolename': 'supervisor',
  'cloud_ipaddress': 'local_ipv4',
}

default['cesi']['service'] = {
  'name': 'cesi',
  'host': '0.0.0.0',
  'port': 5000,
  'debug': false,
  'auto_reload': false,
}
