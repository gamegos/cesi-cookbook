#
# Cookbook:: cesi
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

node.override['poise-python']['options']['pip_version'] = '18.0'

cesi_user = node['cesi']['user']
cesi_group = node['cesi']['group']
cesi_version = node['cesi']['version']
cesi_setup_path = node['cesi']['setup_path']
cesi_database = node['cesi']['conf']['database']
cesi_activity_log = node['cesi']['conf']['activity_log']
cesi_nodes = node['cesi']['conf']['nodes']

cesi_release_setup_path = "#{cesi_setup_path}/#{cesi_version}"

unless cesi_database.start_with?('/')
  cesi_database = "#{cesi_release_setup_path}/#{cesi_database}"
end
unless cesi_activity_log.start_with?('/')
  cesi_activity_log = "#{cesi_release_setup_path}/#{cesi_activity_log}"
end

is_cesi_installed_once = File.exist?(cesi_setup_path)
is_this_cesi_release_installed = File.exist?(cesi_release_setup_path)

# Stop cesi service, when we are upgrading cesi.
if is_cesi_installed_once && !is_this_cesi_release_installed
  service 'cesi' do
    action %i[disable stop]
  end
end

group cesi_group

user cesi_user do
  manage_home false
  shell '/bin/nologin'
  gid cesi_group
  home cesi_setup_path
end

directory cesi_release_setup_path do
  owner cesi_user
  group cesi_group
  recursive true
  notifies :extract, "tar_extract[#{node['cesi']['release']['url']}]", :immediately
end

tar_extract node['cesi']['release']['url'] do
  user cesi_user
  group cesi_group
  target_dir cesi_release_setup_path
  creates "#{cesi_release_setup_path}/README.md"
  tar_flags ['-P', '--strip-components 1']
  action :nothing
end

# Install python3
case node['platform_family']
when 'debian'
  # do things on debian-ish platforms (debian, ubuntu, linuxmint)
  case node['platform']
  when 'ubuntu'
    if node['platform_version'].to_f.between?(14.04, 17.10)
      python_runtime '3'
    elsif node['platform_version'].to_f > 17.10
      # python_runtime '3'  # Not working.
      # https://github.com/poise/poise-python/issues/116
      # https://github.com/poise/poise-python/issues/117
      # https://github.com/poise/poise-python/issues/127
      package 'python3-distutils'
      python_runtime '3.6' do
        version '3.6'
        options :system
      end
    else
      raise 'Not supported ubuntu version.'
    end
  when 'debian'
    if node['platform_version'].to_f >= 8.0
      python_runtime '3'
    else
      raise 'Not supported debian version.'
    end
  else
    raise 'We support only ubuntu in debian-ish platform.'
  end
when 'rhel'
  # do things on RHEL platforms (redhat, centos, etc)
  case node['platform']
  when 'centos'
    if node['platform_version'].to_f >= 7.0
      yum_package 'epel-release' do
        action :install
      end
      python_runtime '3.6' do
        provider :system
        options package_name: 'python36'
      end
      link '/usr/bin/python3' do
        to      '/usr/bin/python36'
        only_if 'test -f /usr/bin/python36'
      end
    else
      raise 'Not supported centos version.'
    end
  else
    raise 'We support only centos in RHEL platforms.'
  end
else
  raise 'Not supported platform.'
end

python_virtualenv 'cesi.virtualenv' do
  path "#{cesi_release_setup_path}/.venv"
  user cesi_user
  group cesi_group
end

pip_requirements 'cesi.requirements' do
  path "#{cesi_release_setup_path}/requirements.txt"
  user cesi_user
  group cesi_group
end

# Search All Supervisor Nodes
supervisor_nodes = []
supervisors_rolename = node['cesi']['supervisors']['rolename']
all_supervisor_nodes = search('node', "role:#{supervisors_rolename}")

unless all_supervisor_nodes.empty?
  all_supervisor_nodes.each do |n|
    if n.key?(:cloud)
      ipaddress_configuration = node['cesi']['supervisors']['cloud_ipaddress']
      host = n['cloud'][ipaddress_configuration]
    else
      host = n['ipaddress']
    end
    supervisor_node = {
      'name': n['hostname'],
      'environment': '',
      'host': host,
      'username': n['supervisor']['inet_http_server']['inet_username'],
      'password': n['supervisor']['inet_http_server']['inet_password'],
      'port': n['supervisor']['inet_http_server']['inet_port'].split(':')[1]
    }
    supervisor_nodes.push(supervisor_node)
  end
end

cesi_nodes = supervisor_nodes unless supervisor_nodes.empty?

# Generate cesi.conf file
template "#{cesi_release_setup_path}/cesi.conf" do
  source 'cesi.conf.erb'
  mode '0644'
  owner cesi_user
  group cesi_group
  variables(
    'nodes': cesi_nodes,
    'database': cesi_database,
    'activity_log': cesi_activity_log,
    'host': node['cesi']['conf']['host'],
    'port': node['cesi']['conf']['port'],
    'name': node['cesi']['conf']['name'],
    'theme': node['cesi']['conf']['theme'],
    'debug': node['cesi']['conf']['debug'],
    'auto_reload': node['cesi']['conf']['auto_reload'],
    'admin_username': node['cesi']['conf']['admin_username'],
    'admin_password': node['cesi']['conf']['admin_password']
  )
  if is_this_cesi_release_installed
    notifies :restart, 'poise_service[cesi]', :immediately
  end
end

poise_service 'cesi' do
  command "#{cesi_release_setup_path}/.venv/bin/python3 "\
          "#{cesi_release_setup_path}/cesi/run.py "\
          "--config #{cesi_release_setup_path}/cesi.conf"
  user cesi_user
end
