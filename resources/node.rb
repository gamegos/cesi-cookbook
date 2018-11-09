# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
property :name, String, name_property: true
property :environment, String, default: ''
property :username, String, default: ''
property :password, String, default: ''
property :host, String, default: '0.0.0.0'
property :port, String, default: '9001'

action :create do
  # Todo
end
