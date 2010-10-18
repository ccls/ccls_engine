require 'ruby_extension'
require 'rails_helpers'
require 'gravatar'
require 'calnet_authenticated'
require 'acts_as_list'

#	This doesn't seem necessary
#%w{models controllers}.each do |dir|
#	path = File.expand_path(File.join(File.dirname(__FILE__), '../app', dir))
#	ActiveSupport::Dependencies.autoload_paths << path
#end

HTML::WhiteListSanitizer.allowed_attributes.merge(%w(
	id class style
))

require 'ccls_engine/date_and_time_formats'
require 'ccls_engine/core_extension'
require 'ccls_engine/user_model'
require 'ccls_engine/authorization'
require 'ccls_engine/helper'
require 'ccls_engine/controller'
require 'ccls_engine/resourceful_controller'
require 'ccls_engine/permissive_controller'
require 'ccls_engine/redcloth/formatters/html'

if !defined?(RAILS_ENV) || RAILS_ENV == 'test'
	require 'active_support'
	require 'active_support/test_case'
	require 'factory_girl'
	require 'assert_this_and_that'
	require 'ccls_engine/factories'
	require 'ccls_engine/factory_test_helper'
	require 'ccls_engine/pending'
end

if RUBY_PLATFORM =~ /java/i
	require 'ccls_engine/file_utils_extension'
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

require 'paperclip'
if defined? ::Paperclip::Glue
	ActiveRecord::Base.send(:include, ::Paperclip::Glue)
else
	ActiveRecord::Base.send(:include, ::Paperclip)
end
