puts "in ccls_engine"
require 'ccls_engine/shared_database'

require 'active_support'
require 'ruby_extension'
require 'simply_helpful'
require 'gravatar'
require 'calnet_authenticated'
require 'simply_authorized'
require 'acts_as_list'
require 'simply_pages'
module Ccls
#	predefine namespace
end
module CclsEngine
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
require 'ccls_engine/user_model'
require 'ccls_engine/helper'

if !defined?(RAILS_ENV) || RAILS_ENV == 'test'
	require 'active_support/test_case'
	require 'factory_girl'
	require 'simply_testable'
	require 'ccls_engine/factories'
end

silence_warnings {
	#	This will complain that the constant is already defined.
	ActionView::Helpers::AssetTagHelper::JAVASCRIPT_DEFAULT_SOURCES = [
		'jquery','jquery-ui','jrails']
}
ActionView::Helpers::AssetTagHelper::reset_javascript_include_default
ActionView::Helpers::AssetTagHelper.register_javascript_include_default(
	'ucb_ccls_engine.js')
ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion( 
	:defaults => ['scaffold','application'] )

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
	:dk    => 999
}).freeze

Survey.use_db :prefix => 'shared_'
SurveySection.use_db :prefix => 'shared_'
Question.use_db :prefix => 'shared_'
QuestionGroup.use_db :prefix => 'shared_'
Answer.use_db :prefix => 'shared_'
ResponseSet.use_db :prefix => 'shared_'
Response.use_db :prefix => 'shared_'
Dependency.use_db :prefix => 'shared_'
DependencyCondition.use_db :prefix => 'shared_'
Validation.use_db :prefix => 'shared_'
ValidationCondition.use_db :prefix => 'shared_'
Track.use_db :prefix => 'shared_'

