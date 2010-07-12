require 'ucb_ccls_auth_plugin'
#require 'auth_by_authlogic'
require 'auth_by_ucb_cas'

if !defined?(RAILS_ENV) || RAILS_ENV == 'test'
	$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../test')
#	require 'authlogic_test_helper'
	require 'ucb_cas_test_helper'
end

# For CAS / CalNet Authentication
config.gem "rubycas-client"

# probably will come from http://gemcutter.org/gems/ucb_ldap
# version 1.3.2 as of Jan 25, 2010
config.gem "ucb_ldap", :source => "http://gemcutter.org"

config.gem 'gravatar'

# http://railscasts.com/episodes/160-authlogic
# http://asciicasts.com/episodes/160-authlogic
# version 2.1.4 includes patches for Rails 3 that
# are not compatible with Rails 2.3.4
# acts_as_authentic/password.rb line 185
# session/callbacks.rb line 69
#   change singleton_class back to metaclass
# config.gem 'authlogic', :version => '>= 2.1.5'

config.reload_plugins = true if RAILS_ENV == 'development'

