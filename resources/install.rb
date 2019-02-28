# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
property :version, String, name_property: true
property :user, String, default: lazy { node['cesi']['user'] }
property :group, String, default: lazy { node['cesi']['group'] }
property :setup_path, String, default: lazy { node['cesi']['setup_path'] }
property :release_url, String, default: ''

action :create do
  node.override['poise-python']['options']['pip_version'] = '18.0'

  cesi_version = new_resource.version
  cesi_user = new_resource.user
  cesi_group = new_resource.group
  cesi_setup_path = new_resource.setup_path
  cesi_release_setup_path = "#{cesi_setup_path}/#{cesi_version}"
  cesi_release_url = new_resource.release_url
  if cesi_release_url == ''
    cesi_release_url = "https://github.com/gamegos/cesi/releases/download/v#{new_resource.version}/cesi-extended.tar.gz"
  end

  node.run_state['cesi'] ||= {}
  node.run_state['cesi']['user'] = cesi_user
  node.run_state['cesi']['group'] = cesi_group
  node.run_state['cesi']['setup_path'] = cesi_setup_path
  node.run_state['cesi']['release_setup_path'] = cesi_release_setup_path

  is_cesi_installed_once = ::File.exist?(cesi_setup_path)
  is_this_cesi_release_installed = ::File.exist?(cesi_release_setup_path)

  # Stop cesi service, when we are upgrading cesi.
  if is_cesi_installed_once && !is_this_cesi_release_installed
    service 'cesi' do
      action %w(disable stop)
    end
  end

  declare_resource(:group, cesi_group)

  declare_resource(:user, cesi_user) do
    manage_home false
    shell '/bin/nologin'
    gid cesi_group
    home cesi_setup_path
  end

  directory cesi_release_setup_path do
    owner cesi_user
    group cesi_group
    recursive true
    notifies :extract, "tar_extract[#{cesi_release_url}]", :immediately
  end

  tar_extract cesi_release_url do
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
end
