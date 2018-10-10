name 'cesi'
maintainer 'pleycpl'
maintainer_email 'h4rvey@protonmail.com'
license 'GPL-3.0'
description 'Installs/Configures cesi'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

supports 'ubuntu', '>= 16.04'
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

depends 'tar'
depends 'poise-python'
depends 'poise-service'
