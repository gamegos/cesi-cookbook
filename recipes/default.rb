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
