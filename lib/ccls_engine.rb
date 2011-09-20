require 'ccls_engine/shared_database'

require 'active_record'
require 'active_support'
require 'action_controller'

gem 'jakewendt-ruby_extension'
require 'ruby_extension'
gem 'jakewendt-simply_helpful'
require 'simply_helpful'
gem 'ccls-calnet_authenticated', '>= 1.1.4'
require 'ccls-calnet_authenticated'
require 'gravatar'

gem 'rubycas-client', '>= 2.2.1'
require 'rubycas-client'
require 'casclient'
require 'casclient/frameworks/rails/filter'
gem 'ucb_ldap', '>= 1.4.2'
require 'ucb_ldap'

gem 'jakewendt-simply_authorized'
require 'simply_authorized'
gem 'ryanb-acts-as-list'
require 'acts_as_list'
gem 'jakewendt-simply_pages'
require 'simply_pages'

gem 'jakewendt-rails_extension'
require 'jakewendt-rails_extension'
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
require 'ccls_engine/ccls_study_subject'
require 'ccls_engine/helper'

if defined?(Rails) && Rails.env == 'test' && Rails.class_variable_defined?("@@configuration")
	require 'active_support/test_case'
	require 'ccls_engine/factory_test_helper'
	require 'ccls_engine/package_test_helper'
	require 'ccls_engine/assertions'
	require 'factory_girl'
	require 'ccls_engine/factories'
end

#silence_warnings {
#	#	This will complain that the constant is already defined.
#	#	Doing this to remove rails default of prototype/scriptaculous,
#	#		but I'm going to stop using :defaults and use :ccls
#	ActionView::Helpers::AssetTagHelper::JAVASCRIPT_DEFAULT_SOURCES = [
#		'jquery','jquery-ui','jrails']
#}
#ActionView::Helpers::AssetTagHelper::reset_javascript_include_default
#ActionView::Helpers::AssetTagHelper.register_javascript_include_default(
#	'ucb_ccls_engine.js')
#ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion( 
#	:defaults => ['scaffold','application'] )


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

require 'simply_trackable'
Track.use_db :prefix => 'shared_'

