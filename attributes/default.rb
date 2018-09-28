# Defaults
default['cesi']['user'] = 'cesi'
default['cesi']['group'] = 'cesi'
default['cesi']['setup_path'] = '/opt/cesi'
default['cesi']['git']['repository'] = 'https://github.com/gamegos/cesi.git'
default['cesi']['git']['revision'] = 'master'

default['cesi']['conf'] = {
  'database': 'userinfo.db',
  'activity_log': 'activity_log',
  'host': '0.0.0.0',
  'port': '5000',
  'name': 'CeSI',
  'theme': 'superhero',
  'debug': 'True',
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
  'name': 'node1',
  'username': '',
  'password': '',
  'host': 'localhost',
  'port': '9002',
}]