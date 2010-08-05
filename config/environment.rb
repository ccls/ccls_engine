#	#	This file is here so that the plugin/engine can
#	#	run standard rails rake tasks.
#	require File.join(File.dirname(__FILE__), 'boot')
#	Rails::Initializer.run do |config|
#	#	Trying to make engine routes play nice with app routes.
#	#	Not going so well.
#	#	config.routes_configuration_file = File.expand_path(
#	#		File.join(File.dirname(__FILE__),'engine_routes.rb'))
#	end


# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

#ENV['RAILS_ENV'] = 'test'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

	config.plugin_paths = [
		File.expand_path(File.join(File.dirname(__FILE__),'../..')),
		File.expand_path(File.join(File.dirname(__FILE__),'../../..','peter')),
		File.expand_path(File.join(File.dirname(__FILE__),'../../..','aaronchi'))
	]
	config.plugins = [:ucb_ccls_engine,
		:jrails,
		:html_test,
		:html_test_extension]

	config.frameworks -= [:active_resource]

	config.action_controller.relative_url_root = ''

	config.routes_configuration_file = File.expand_path(
		File.join(File.dirname(__FILE__),'..','test/config/routes.rb'))

	config.load_paths += [
		File.expand_path(
			File.join(File.dirname(__FILE__),'..','test/app/models')),
		File.expand_path(
			File.join(File.dirname(__FILE__),'..','test/app/controllers'))
	]

	config.eager_load_paths += [
		File.expand_path(
			File.join(File.dirname(__FILE__),'..','test/app/models')),
		File.expand_path(
			File.join(File.dirname(__FILE__),'..','test/app/controllers'))
	]

	config.controller_paths += [
		File.expand_path(
			File.join(File.dirname(__FILE__),'..','test/app/controllers'))
	]


#		config.gem "rcov"
#	
#		#	Without the :lib => false, the 'rake test' actually fails?
#		config.gem "mocha", :lib => false
	
		if RUBY_PLATFORM =~ /java/
			#	I'm surprised that I don't need this in my apps.
			config.gem 'activerecord-jdbcsqlite3-adapter',
				:lib => 'active_record/connection_adapters/jdbcsqlite3_adapter'
			config.gem 'jdbc-sqlite3', :lib => 'jdbc/sqlite3'
			config.gem 'jruby-openssl', :lib => 'openssl'
		else
			config.gem "sqlite3-ruby", :lib => "sqlite3"
		end
	
#		config.gem "autotest-rails", :lib => 'autotest/rails'
#	
#		config.gem "ZenTest"
#	
#		config.gem "thoughtbot-factory_girl",
#			:lib    => "factory_girl",
#			:source => "http://gems.github.com"
	
		config.action_mailer.default_url_options = { 
			:host => "localhost:3000" }

end
