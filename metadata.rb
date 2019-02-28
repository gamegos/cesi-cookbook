name 'cesi'
maintainer 'Fatih Sarhan'
maintainer_email 'f9n@protonmail.com'
license 'GPL-3.0'
description 'Installs/Configures cesi'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
chef_version '>= 12.0'

supports 'debian', '>= 8.0'
supports 'ubuntu', '>= 14.04'
supports 'centos', '>= 7.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/gamegos/cesi-cookbook/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/gamegos/cesi-cookbook'

depends 'tar', '~> 2.2.0'
depends 'poise-python', '~> 1.7.0'
depends 'poise-service', '~> 1.5.2'
