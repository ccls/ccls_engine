# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

ENV['RAILS_ENV'] = 'test'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
#	puts "Why am I executed 3 times?"
#	Once for each dir containing testable files it seems
#	test/ucb_ccls_engine_test.rb
#	test/unit/*
#	test/functional/*

	config.plugin_paths = [
		File.expand_path(File.join(File.dirname(__FILE__),'../../..'))]
	config.plugins = [:ucb_ccls_engine]

	config.routes_configuration_file = File.expand_path(
		File.join(File.dirname(__FILE__),'../..','config/routes.rb'))
	
	config.load_paths += [
		File.expand_path(
			File.join(File.dirname(__FILE__),'../..','app/models')),
		File.expand_path(
			File.join(File.dirname(__FILE__),'../..','app/controllers'))
	]

	config.eager_load_paths += [
		File.expand_path(
			File.join(File.dirname(__FILE__),'../..','app/models')),
		File.expand_path(
			File.join(File.dirname(__FILE__),'../..','app/controllers'))
	]

	config.controller_paths += [
		File.expand_path(
			File.join(File.dirname(__FILE__),'../..','app/controllers'))
	]

	config.view_path = File.expand_path(
		File.join(File.dirname(__FILE__),'../..','app/views'))

	config.frameworks -= [:active_resource]

#	puts config.inspect
end
