require 'ccls_engine/date_and_time_formats'
require 'ccls_engine/core_extension'
require 'ccls_engine/user_model'
require 'ccls_engine/authorization'
require 'ccls_engine/helper'
require 'ccls_engine/controller'
require 'ccls_engine/redcloth/formatters/html'


if !defined?(RAILS_ENV) || RAILS_ENV == 'test'
	$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../test')
	$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../test/helpers')

	require 'factory_girl'
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
