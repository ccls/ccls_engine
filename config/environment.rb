# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.14' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

#       This constant is used in the ucb_ccls_engine#Document
#       and other places like Amazon buckets
#       for controlling the path to documents.
RAILS_APP_NAME = 'ccls'

Rails::Initializer.run do |config|

	config.frameworks -= [:active_resource]

#	config.routes_configuration_file = File.expand_path(
#		File.join(File.dirname(__FILE__),'..','test/config/routes.rb'))

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
		config.gem "sqlite3"
	end

	config.gem 'ccls-calnet_authenticated', :version => '>= 1.2.0'

	config.gem "ccls-use_db"
	config.gem 'ccls-simply_authorized'
	config.gem 'ccls-common_lib'
	config.gem 'jrails'

	#		http://chronic.rubyforge.org/
#	config.gem "chronic"

#	20120213 - Removing this feature
#	config.gem 'active_shipping'
	config.gem 'will_paginate'
	config.gem 'fastercsv'


#	Rails 2 requires us to not use the latest version of delayed_job.
#	delayed_job depends upon version 1.0.10 of the daemons gem. 
#	delayed_job is incompatible with the newest (1.1.0) daemons gem.
#	config.gem 'delayed_job', :version => '~>2.0.4'



#	needed for testing
	config.time_zone = 'Pacific Time (US & Canada)'



	config.after_initialize do
		load File.expand_path(File.join(File.dirname(__FILE__),'../lib/ccls_engine.rb'))
	end
end
