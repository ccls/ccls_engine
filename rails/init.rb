$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../config')
require 'environment'
require 'ucb_ccls_auth_plugin'
#require 'auth_by_authlogic'
require 'auth_by_ucb_cas'

if !defined?(RAILS_ENV) || RAILS_ENV == 'test'
	$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../test')
#	require 'authlogic_test_helper'
	require 'ucb_cas_test_helper'
end
