##	This won't actually load, but it will cause
##	an error if a newer version is loaded.
##	Newer versions are incompatible with rails 2.3.8
#config.gem 'i18n', :version => '=0.3.7'
#
#config.gem 'jrails'
#
#config.gem 'jakewendt-rails_helpers',
#	:lib    => 'rails_helpers', 
#	:source => 'http://rubygems.org'
#
#config.gem 'jakewendt-ruby_extension',
#	:lib    => 'ruby_extension', 
#	:source => 'http://rubygems.org'
#
#config.gem "chronic"
#
#config.gem "ruby-hmac", :lib => "ruby_hmac"
#
#config.gem "aws-s3", :lib => "aws/s3"
#
#config.gem 'ssl_requirement'

config.gem 'ryanb-acts-as-list', 
	:lib => 'acts_as_list', 
	:source => 'http://gems.github.com'

#config.gem 'gravatar'
#
#config.gem "RedCloth"
#
#config.gem 'paperclip'
#
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
	require 'ccls_engine'
end	#	config.after_initialize
