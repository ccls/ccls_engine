require 'ccls_engine/shared_database'

#gem 'delayed_job', '~>2.0.4'
#Delayed::Backend::ActiveRecord::Job.class_eval do
#	use_db :prefix => "shared_"
#end

require 'active_record'
require 'active_support'
require 'action_controller'

gem 'ccls-common_lib'
require 'common_lib'

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

module Ccls
#	predefine namespace
end


#
#	As this gem has controllers, which are subclasses of ApplicationController,
#		in development mode, ApplicationController loads and unloads, which will
#		cause the following error after the first request.  I'd really prefer
#		to find a better solution.  The basic problem is creating a class in this
#		gem that is a subclass of a class defined in the app.
#	This is really only needed in development mode.  I'm not sure what'll 
#		happen in production, but should work as well.
#	It does mean that if you change application_controller in dev mode,
#		you'll need to restart the app to see the changes as it won't reload.
#
#	A better solution would be to add the controllers, views and routes
#		to the generator installation and actually have them in the app.
#		Or just put them their by hand.  But now they won't be DRY.  BooHoo.
#
#
#	Processing ZipCodesController#index to json (for 169.229.196.225 at 2011-11-15 13:50:34) [GET]
#	  Parameters: {"q"=>"1785"}
#	
#	ArgumentError (A copy of ApplicationController has been removed from the module tree but is still active!):
#	  app/controllers/application_controller.rb:121:in `get_guidance'
#	Rendered rescues/_trace (99.8ms)
#	Rendered rescues/_request_and_response (1.2ms)
#	Rendering rescues/layout (internal_server_error)
#require 'application_controller'


#	This doesn't seem necessary.  Removing it doesn't seem to do anything.
#	And having it doesn't seem to do anything?
#	Maybe the latest rails gem does this automagically?
#%w{models controllers}.each do |dir|
#	path = File.expand_path(File.join(File.dirname(__FILE__), '../app', dir))
#	ActiveSupport::Dependencies.autoload_paths << path
#	ActiveSupport::Dependencies.autoload_once_paths << path
#end




HTML::WhiteListSanitizer.allowed_attributes.merge(%w(
	id class style
))

require 'ccls_engine/date_and_time_formats'
require 'ccls_engine/core_extension'
require 'ccls_engine/active_record_shared'
require 'ccls_engine/ccls_user'
require 'ccls_engine/translation_table'
require 'ccls_engine/helper'
require 'ccls_engine/active_record_extension'
require 'ccls_engine/action_view_extension'

if defined?(Rails) && Rails.env == 'test' && Rails.class_variable_defined?("@@configuration")
	require 'active_support/test_case'
	require 'ccls_engine/factory_test_helper'
	require 'ccls_engine/package_test_helper'
	require 'ccls_engine/assertions'
	require 'factory_girl'
	require 'ccls_engine/factories'

	#	These are not automatically included as they
	#		contain duplicate methods names.
	#	They must be explicitly included in the test classes
	#		that use them.
	require 'ccls_engine/icf_master_tracker_update_test_helper'
	require 'ccls_engine/live_birth_data_update_test_helper'
end

ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion( 
	:ccls => ['scaffold','ccls_engine','application'] )
ActionView::Helpers::AssetTagHelper.register_javascript_expansion( 
	:ccls => ['jquery','jquery-ui','jrails','application'] )


#ActionController::Routing::Routes.add_configuration_file(
#	File.expand_path(
#		File.join(
#			File.dirname(__FILE__), '../config/routes.rb')))
#
#ActionController::Base.view_paths <<
#	File.expand_path(
#		File.join(
#			File.dirname(__FILE__), '../app/views'))



gem 'paperclip', '= 2.4.2'
require 'paperclip'
if defined? ::Paperclip::Glue
	ActiveRecord::Base.send(:include, ::Paperclip::Glue)
else
	ActiveRecord::Base.send(:include, ::Paperclip)
end

##	methods or constants?
def valid_sex_values
	%w( M F DK )
end
