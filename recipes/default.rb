#
# Cookbook:: cesi
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

cesi_install node['cesi']['version']

cesi_config node['cesi']['supervisors']['rolename']

cesi_service node['cesi']['service']['name']
