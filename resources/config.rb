# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
property :supervisors_rolename, String, name_property: true
property :database_uri, String, default: lazy { node['cesi']['conf']['database_uri'] }
property :activity_log, String, default: lazy { node['cesi']['conf']['activity_log'] }
property :admin_username, String, default: lazy { node['cesi']['conf']['admin_username'] }
property :admin_password, String, default: lazy { node['cesi']['conf']['admin_password'] }
property :cloud_ipaddress, String, default: lazy { node['cesi']['supervisors']['cloud_ipaddress'] }
property :template, String, default: 'cesi'

action :create do
  supervisors_rolename = new_resource.supervisors_rolename

  # Search All Supervisor Nodes
  supervisor_nodes = []
  all_supervisor_nodes = search('node', "role:#{supervisors_rolename}")

  unless all_supervisor_nodes.empty?
    all_supervisor_nodes.each do |n|
      cloud = n.fetch(:cloud, nil)
      if cloud
        ipaddress_configuration = new_resource.cloud_ipaddress
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

  # Generate cesi.conf.toml file
  template 'cesi.conf.toml' do
    cookbook new_resource.template
    path lazy { "#{node.run_state['cesi']['release_setup_path']}/cesi.conf.toml" }
    source 'cesi.conf.toml.erb'
    mode '0644'
    owner lazy { node.run_state['cesi']['user'] }
    group lazy { node.run_state['cesi']['group'] }
    variables(
      'nodes': cesi_nodes,
      'database_uri': new_resource.database_uri,
      'activity_log': new_resource.activity_log,
      'admin_username': new_resource.admin_username,
      'admin_password': new_resource.admin_password
    )
  end
end
