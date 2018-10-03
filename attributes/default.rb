# Defaults
default['cesi']['user'] = 'cesi'
default['cesi']['group'] = 'cesi'
default['cesi']['setup_path'] = '/opt/cesi'
default['cesi']['version'] = '2.0'
default['cesi']['release']['url'] = "https://github.com/gamegos/cesi/archive/v#{default['cesi']['version']}.tar.gz"
default['cesi']['release']['build-ui'] = "https://github.com/gamegos/cesi/releases/download/v#{default['cesi']['version']}/build-ui.tar"

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
  'admin_password': 'admin',
}

default['cesi']['conf']['environments'] = [{
  'name': 'example',
  'members': 'node1,node2',
}]

default['cesi']['conf']['nodes'] = [{
  'name': 'node1',
  'username': '',
  'password': '',
  'host': 'localhost',
  'port': '9001',
}, {
  'name': 'node2',
  'username': '',
  'password': '',
  'host': 'localhost',
  'port': '9002',
}]

default['cesi']['supervisors_rolename'] = 'supervisor'
