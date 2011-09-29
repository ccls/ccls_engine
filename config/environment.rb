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

	config.routes_configuration_file = File.expand_path(
		File.join(File.dirname(__FILE__),'..','test/config/routes.rb'))

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

	config.gem 'ccls-common_lib'

	config.gem "jakewendt-use_db"
	config.gem 'jakewendt-simply_trackable'
	config.gem 'jakewendt-simply_authorized'
	config.gem 'jakewendt-simply_pages'	#	TODO remove me
	config.gem 'jakewendt-simply_helpful'
	#	require it, but don't load it
#	config.gem 'jakewendt-rdoc_rails', :lib => false
	config.gem 'jrails'

	config.gem 'haml'      # Needed for Surveyor
	#		http://chronic.rubyforge.org/
	config.gem "chronic"	#, :version => '= 0.5.0'
	config.gem 'active_shipping'
	config.gem 'will_paginate'
	config.gem 'fastercsv'
#	config.gem 'paperclip'

	config.after_initialize do
		load File.expand_path(File.join(File.dirname(__FILE__),'../lib/ccls_engine.rb'))
	end
end
