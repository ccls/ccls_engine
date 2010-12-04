# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.10' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

#       This constant is used in the ucb_ccls_engine#Document
#       and other places like Amazon buckets
#       for controlling the path to documents.
RAILS_APP_NAME = 'ccls'

Rails::Initializer.run do |config|

#	config.gem 'jakewendt-simply_testable',
#		:lib => 'simply_testable'
#
#	config.gem 'ryanb-acts-as-list',
#		:lib => 'acts_as_list'

	config.plugin_paths += [
		File.expand_path(File.join(File.dirname(__FILE__),'../..')),
		File.expand_path(File.join(File.dirname(__FILE__),'../../..','peter')),
		File.expand_path(File.join(File.dirname(__FILE__),'../../..','jakewendt'))
	]
	config.plugins = [:ucb_ccls_engine,
		:html_test, :html_test_extension]

	config.frameworks -= [:active_resource]

	config.routes_configuration_file = File.expand_path(
		File.join(File.dirname(__FILE__),'..','test/config/routes.rb'))

	config.autoload_paths += [
		File.expand_path(
			File.join(File.dirname(__FILE__),'..','test/app/models')),
		File.expand_path(
			File.join(File.dirname(__FILE__),'..','test/app/controllers'))
	]

#	config.eager_load_paths += [
#		File.expand_path(
#			File.join(File.dirname(__FILE__),'..','test/app/models')),
#		File.expand_path(
#			File.join(File.dirname(__FILE__),'..','test/app/controllers'))
#	]
#
#	config.controller_paths += [
#		File.expand_path(
#			File.join(File.dirname(__FILE__),'..','test/app/controllers'))
#	]

	config.view_path = [
		File.expand_path(
			File.join(File.dirname(__FILE__),'..','test/app/views'))
	]

	if RUBY_PLATFORM =~ /java/
		config.gem 'activerecord-jdbcsqlite3-adapter',
			:lib => 'active_record/connection_adapters/jdbcsqlite3_adapter'
		config.gem 'activerecord-jdbcmysql-adapter',
			:lib => 'active_record/connection_adapters/jdbcmysql_adapter'
		config.gem 'jdbc-mysql', :lib => 'jdbc/mysql'
		config.gem 'jdbc-sqlite3', :lib => 'jdbc/sqlite3'
		config.gem 'jruby-openssl', :lib => 'openssl'
	else
		config.gem 'mysql'
		config.gem "sqlite3-ruby", :lib => "sqlite3"
	end

	config.gem "jakewendt-use_db", :lib => "use_db"
	config.gem "thoughtbot-factory_girl", :lib => "factory_girl"
	

	config.gem 'jakewendt-simply_trackable',
		:lib    => 'simply_trackable'

config.gem "rcov"

#	Without the :lib => false, the 'rake test' actually fails?
config.gem "mocha", :lib => false

config.gem "autotest-rails", :lib => 'autotest/rails'

config.gem "ZenTest"

	config.gem 'haml'      # Needed for Surveyor
	#	Keep chronic here
	config.gem "chronic"   #		http://chronic.rubyforge.org/
	config.gem 'active_shipping'
	config.gem 'will_paginate'
	config.gem 'fastercsv'
	config.gem 'paperclip'


	config.action_mailer.default_url_options = { 
		:host => "localhost:3000" }

end
