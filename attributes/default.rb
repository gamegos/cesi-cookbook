# Defaults
default['cesi']['user'] = 'cesi'
default['cesi']['group'] = 'cesi'
default['cesi']['setup_path'] = '/opt/cesi'
default['cesi']['version'] = '2.3'
default['cesi']['release']['url'] = "https://github.com/gamegos/cesi/releases/download/v#{default['cesi']['version']}/cesi.tar.gz"

default['cesi']['conf'] = {
  'database': 'userinfo.db',
  'activity_log': 'activity_log',
  'host': '0.0.0.0',
  'port': '5000',
  'name': 'CeSI',
  'theme': 'superhero',
  'debug': 'False',
  'auto_reload': 'False',
  'admin_username': 'admin',
  'admin_password': 'admin'
}

default['cesi']['conf']['nodes'] = []
# [{
#   'name': 'node1',
#   'environment': 'aws',
#   'username': '',
#   'password': '',
#   'host': 'localhost',
#   'port': '9001',
# }, {
#   'name': 'node2',
#   'environment': 'azure',
#   'username': '',
#   'password': '',
#   'host': 'localhost',
#   'port': '9002',
# }]

default['cesi']['supervisors'] = {
  'rolename': 'supervisor',
  'cloud_ipaddress': 'local_ipv4'
}
