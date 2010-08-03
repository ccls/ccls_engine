#			# Be sure to restart your server when you modify this file
#			
#			# Specifies gem version of Rails to use when vendor/rails is not present
#			#RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION
#			
#			#ENV['RAILS_ENV'] = 'test'
#			
#			# Bootstrap the Rails environment, frameworks, and default configuration
#			require File.join(File.dirname(__FILE__), 'boot')
#			
#			Rails::Initializer.run do |config|
#			#	puts "Why am I executed 3 times?"
#			#	Once for each dir containing testable files it seems
#			#	test/ucb_ccls_engine_test.rb
#			#	test/unit/*
#			#	test/functional/*
#			
#				config.plugin_paths = [
#					File.expand_path(File.join(File.dirname(__FILE__),'../../..'))]
#				config.plugins = [:ucb_ccls_engine]
#			
#				config.routes_configuration_file = File.expand_path(
#					File.join(File.dirname(__FILE__),'routes.rb'))
#			#		File.join(File.dirname(__FILE__),'../..','config/routes.rb'))
#				
#				config.load_paths += [
#					File.expand_path(
#						File.join(File.dirname(__FILE__),'../..','app/models')),
#					File.expand_path(
#						File.join(File.dirname(__FILE__),'../..','app/controllers'))
#				]
#			
#				config.eager_load_paths += [
#					File.expand_path(
#						File.join(File.dirname(__FILE__),'../..','app/models')),
#					File.expand_path(
#						File.join(File.dirname(__FILE__),'../..','app/controllers'))
#				]
#			
#				config.controller_paths += [
#					File.expand_path(
#						File.join(File.dirname(__FILE__),'../..','app/controllers'))
#				]
#			
#				config.view_path = File.expand_path(
#					File.join(File.dirname(__FILE__),'../..','app/views'))
#			
#				config.frameworks -= [:active_resource]
#			
#				# The test environment is used exclusively to run your application's
#				# test suite.  You never need to work with it otherwise.  Remember that
#				# your test database is "scratch space" for the test suite and is wiped
#				# and recreated between test runs.  Don't rely on the data there!
#				config.cache_classes = true
#			
#				# Log error messages when you accidentally call methods on nil.
#				config.whiny_nils = true
#			
#				# Show full error reports and disable caching
#				config.action_controller.consider_all_requests_local = true
#				config.action_controller.perform_caching             = false
#				config.action_view.cache_template_loading            = true
#			
#				# Disable request forgery protection in test environment
#				config.action_controller.allow_forgery_protection    = false
#			
#				# Tell Action Mailer not to deliver emails to the real world.
#				# The :test delivery method accumulates sent emails in the
#				# ActionMailer::Base.deliveries array.
#				config.action_mailer.delivery_method = :test
#			
#				#	Needed due to being in a subdir.
#				config.action_controller.relative_url_root = ''
#			
#				config.gem "rcov"
#			
#				#	Without the :lib => false, the 'rake test' actually fails?
#				config.gem "mocha", :lib => false
#			
#				if RUBY_PLATFORM =~ /java/
#					#	I'm surprised that I don't need this in my apps.
#					config.gem 'activerecord-jdbcsqlite3-adapter',
#						:lib => 'active_record/connection_adapters/jdbcsqlite3_adapter'
#					config.gem 'jdbc-sqlite3', :lib => 'jdbc/sqlite3'
#					config.gem 'jruby-openssl', :lib => 'openssl'
#				else
#					config.gem "sqlite3-ruby", :lib => "sqlite3"
#				end
#			
#				config.gem "autotest-rails", :lib => 'autotest/rails'
#			
#				config.gem "ZenTest"
#			
#				config.gem "thoughtbot-factory_girl",
#					:lib    => "factory_girl",
#					:source => "http://gems.github.com"
#			
#				config.action_mailer.default_url_options = { 
#					:host => "localhost:3000" }
#			
#			end
