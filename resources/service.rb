# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
property :service_name, String, name_property: true
property :host, String, default: lazy { node['cesi']['service']['host'] }
property :port, Integer, default: lazy { node['cesi']['service']['port'] }
property :debug, [TrueClass, FalseClass], default: lazy { node['cesi']['service']['debug'] }
property :auto_reload, [TrueClass, FalseClass], default: lazy { node['cesi']['service']['auto_reload'] }

action :create do
  options = ''
  options << " --host #{new_resource.host}"
  options << " --port #{new_resource.port}"
  options << ' --debug' if new_resource.debug
  options << ' --auto-reload' if new_resource.auto_reload

  poise_service new_resource.service_name do
    command lazy { "#{node.run_state['cesi']['release_setup_path']}/.venv/bin/python  #{node.run_state['cesi']['release_setup_path']}/cesi/run.py --config #{node.run_state['cesi']['release_setup_path']}/cesi.conf.toml #{options}" }
    directory lazy { node.run_state['cesi']['release_setup_path'] }
    user lazy { node.run_state['cesi']['user'] }
  end
end
