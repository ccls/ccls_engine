require 'ccls_engine/shared_database'

require 'active_record'
require 'active_support'
require 'action_controller'

gem 'ccls-common_lib'
require 'common_lib'

#gem 'ccls-ruby_extension'
#require 'ruby_extension'

gem 'ccls-simply_helpful'
require 'simply_helpful'

gem 'ccls-calnet_authenticated', '>= 1.1.4'
require 'ccls-calnet_authenticated'

gem 'rubycas-client', '>= 2.2.1'
require 'rubycas-client'

require 'casclient'
require 'casclient/frameworks/rails/filter'

gem 'ucb_ldap', '>= 1.4.2'
require 'ucb_ldap'

gem 'ccls-simply_authorized'
require 'simply_authorized'

gem 'ryanb-acts-as-list'
require 'acts_as_list'

#gem 'ccls-rails_extension'
#require 'ccls-rails_extension'

module Ccls
#	predefine namespace
end

#	This doesn't seem necessary
%w{models controllers}.each do |dir|
	path = File.expand_path(File.join(File.dirname(__FILE__), '../app', dir))
	ActiveSupport::Dependencies.autoload_paths << path
	ActiveSupport::Dependencies.autoload_once_paths << path
end

HTML::WhiteListSanitizer.allowed_attributes.merge(%w(
	id class style
))

require 'ccls_engine/date_and_time_formats'
require 'ccls_engine/core_extension'
require 'ccls_engine/shared'
require 'ccls_engine/ccls_user'
require 'ccls_engine/helper'

if defined?(Rails) && Rails.env == 'test' && Rails.class_variable_defined?("@@configuration")
	require 'active_support/test_case'
	require 'ccls_engine/factory_test_helper'
	require 'ccls_engine/package_test_helper'
	require 'ccls_engine/assertions'
	require 'factory_girl'
	require 'ccls_engine/factories'
end

ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion( 
	:ccls => ['scaffold','ccls_engine','application'] )
ActionView::Helpers::AssetTagHelper.register_javascript_expansion( 
	:ccls => ['jquery','jquery-ui','jrails','application'] )


ActionController::Routing::Routes.add_configuration_file(
	File.expand_path(
		File.join(
			File.dirname(__FILE__), '../config/routes.rb')))

ActionController::Base.view_paths <<
	File.expand_path(
		File.join(
			File.dirname(__FILE__), '../app/views'))

require 'paperclip'
if defined? ::Paperclip::Glue
	ActiveRecord::Base.send(:include, ::Paperclip::Glue)
else
	ActiveRecord::Base.send(:include, ::Paperclip)
end

#	While a HWIA does not differentiate strings and symbols,
#	it does not differentiate between strings and numbers.

YNDK = HashWithIndifferentAccess.new({
	:yes   => 1,
	:true  => 1,
	:no    => 2,
	:false => 2,
	:dk    => 999,
	'1'    => 'Yes',
	'2'    => 'No',
	'999'  => "Don't Know",
	1      => 'Yes',
	2      => 'No',
	999    => "Don't Know"
}).freeze

YNODK = HashWithIndifferentAccess.new({
	:yes   => 1,
	:true  => 1,
	:no    => 2,
	:false => 2,
	:other => 3,
	:dk    => 999,
	'1'    => 'Yes',
	'2'    => 'No',
	'3'    => 'Other',
	'999'  => "Don't Know",
	1      => 'Yes',
	2      => 'No',
	3      => 'Other',
	999    => "Don't Know"
}).freeze
