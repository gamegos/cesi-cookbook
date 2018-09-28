#
# Cookbook:: cesi
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
include_recipe 'git::default'

cesi_user = node['cesi']['user']
cesi_group = node['cesi']['group']
cesi_setup_path = node['cesi']['setup_path']

group cesi_group

user cesi_user do
  manage_home false
  shell '/bin/nologin'
  gid cesi_group
  home cesi_setup_path
end

directory cesi_setup_path do
  user cesi_user
  group cesi_group
  recursive true
end

git cesi_setup_path do
  repository node['cesi']['git']['repository']
  revision node['cesi']['git']['revision']
  action :sync
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
  else
    raise 'We support only ubuntu in debian-ish platform.'
  end
when 'rhel'
  # do things on RHEL platforms (redhat, centos, etc)
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
  raise 'Not supported platform.'
end

python_virtualenv 'cesi.virtualenv' do
  path "#{cesi_setup_path}/.venv"
  user cesi_user
  group cesi_group
end

pip_requirements 'cesi.requirements' do
  path "#{cesi_setup_path}/requirements.txt"
  user cesi_user
  group cesi_group
end
