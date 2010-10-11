#puts "In Rails/Init"

#	This won't actually load, but it will cause
#	an error if a newer version is loaded.
#	Newer versions are incompatible with rails 2.3.8
config.gem 'i18n', :version => '=0.3.7'

config.gem 'jrails'

config.gem 'jakewendt-rails_helpers',
	:lib    => 'rails_helpers', 
	:source => 'http://rubygems.org'

config.gem 'jakewendt-ruby_extension',
	:lib    => 'ruby_extension', 
	:source => 'http://rubygems.org'

config.gem "chronic"

config.gem "ruby-hmac", :lib => "ruby_hmac"

config.gem "aws-s3", :lib => "aws/s3"

config.gem 'ssl_requirement'

config.gem 'ryanb-acts-as-list', 
	:lib => 'acts_as_list', 
	:source => 'http://gems.github.com'

# For CAS / CalNet Authentication
config.gem "rubycas-client"

# probably will come from http://gemcutter.org/gems/ucb_ldap
# version 1.3.2 as of Jan 25, 2010
config.gem "ucb_ldap", :source => "http://gemcutter.org"

config.gem 'gravatar'

config.gem "RedCloth"
config.after_initialize do
	require 'redcloth_extension/formatters/html'
end

config.gem 'paperclip'
#
#	after_initialize blocks won't be executed if
#	any of the config.gem gems are missing
#	so we don't need the Gem.searcher.find
#	which I do use in the rake file.
#
config.after_initialize do
	#/Library/Ruby/Gems/1.8/gems/activerecord-2.3.8/lib/active_record/base.rb:1994:in `method_missing_without_paginate': undefined method `has_attached_file' for #<Class:0x1070676d0> (NoMethodError)
	#	Why must I do this? Paperclip won't work without it when using a gem.
	require 'paperclip'
	if defined? ::Paperclip::Glue
		ActiveRecord::Base.send(:include, ::Paperclip::Glue)
	else
		ActiveRecord::Base.send(:include, ::Paperclip)
	end
end
		
# http://railscasts.com/episodes/160-authlogic
# http://asciicasts.com/episodes/160-authlogic
# version 2.1.4 includes patches for Rails 3 that
# are not compatible with Rails 2.3.4
# acts_as_authentic/password.rb line 185
# session/callbacks.rb line 69
#   change singleton_class back to metaclass
# config.gem 'authlogic', :version => '>= 2.1.5'

config.autoload_paths << File.expand_path(
	File.join(File.dirname(__FILE__),'..','/app/sweepers'))


#	This works in the app's config/environment.rb ...
#config.action_view.sanitized_allowed_attributes = 'id', 'class', 'style'
#	but apparently not here, so ...
HTML::WhiteListSanitizer.allowed_attributes.merge(%w(
	id class style
))

config.reload_plugins = true if RAILS_ENV == 'development'

#	Load the gems before the files that need them!


if !defined?(RAILS_ENV) || RAILS_ENV == 'test'

	config.gem "thoughtbot-factory_girl",
		:lib    => "factory_girl",
		:source => "http://gems.github.com"

	config.gem 'jakewendt-assert_this_and_that',
		:lib => 'assert_this_and_that',
		:source => 'http://rubygems.org'

end

config.gem 'jakewendt-calnet_authenticated',
	:lib    => 'calnet_authenticated',
	:source => 'http://rubygems.org'

config.after_initialize do
	require 'core_extension'

	require 'ucb_ccls_engine'
#	#require 'auth_by_authlogic'
#	require 'auth_by_ucb_cas'
	require 'authorization'

	require 'ucb_ccls_engine_helper'
	require 'ucb_ccls_engine_controller'

	if !defined?(RAILS_ENV) || RAILS_ENV == 'test'
		$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../test')
		$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../test/helpers')
	#	require 'authlogic_test_helper'
		require 'ucb_cas_test_helper'

		require 'factory_girl'
		require 'ucb_ccls_engine_factories'
		require 'ucb_ccls_engine_factory_test_helper'
		require 'pending'
	end

	if RUBY_PLATFORM =~ /java/i
		require 'file_utils_extension'
	end

	ActionView::Helpers::AssetTagHelper.register_javascript_include_default(
		'ucb_ccls_engine.js')
	ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion( 
		:defaults => ['scaffold','application'] )
end	#	config.after_initialize

require 'date_and_time_formats'
