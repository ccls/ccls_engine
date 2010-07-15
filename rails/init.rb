#puts "In Rails/Init"

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

config.gem 'paperclip'

#/Library/Ruby/Gems/1.8/gems/activerecord-2.3.8/lib/active_record/base.rb:1994:in `method_missing_without_paginate': undefined method `has_attached_file' for #<Class:0x1070676d0> (NoMethodError)
#	Why must I do this? Paperclip won't work without it when using a gem.
require 'paperclip'
ActiveRecord::Base.send(:include, ::Paperclip)

# http://railscasts.com/episodes/160-authlogic
# http://asciicasts.com/episodes/160-authlogic
# version 2.1.4 includes patches for Rails 3 that
# are not compatible with Rails 2.3.4
# acts_as_authentic/password.rb line 185
# session/callbacks.rb line 69
#   change singleton_class back to metaclass
# config.gem 'authlogic', :version => '>= 2.1.5'

config.load_paths << File.expand_path(
	File.join(File.dirname(__FILE__),'..','/app/sweepers'))


#	This works in the app's config/environment.rb ...
#config.action_view.sanitized_allowed_attributes = 'id', 'class', 'style'
#	but apparently not here, so ...
HTML::WhiteListSanitizer.allowed_attributes.merge(%w(
	id class style
))

config.reload_plugins = true if RAILS_ENV == 'development'

#	Load the gems before the files that need them!

require 'ucb_ccls_engine'
#require 'auth_by_authlogic'
require 'auth_by_ucb_cas'
require 'authorization'

require 'ucb_ccls_engine_helper'
require 'ucb_ccls_engine_controller'


if !defined?(RAILS_ENV) || RAILS_ENV == 'test'
	$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../test')
	$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../test/helpers')
#	require 'authlogic_test_helper'
	require 'ucb_cas_test_helper'

	config.gem "thoughtbot-factory_girl",
		:lib    => "factory_girl",
		:source => "http://gems.github.com"

	require 'factory_girl'
	require 'ucb_ccls_engine_factories'
	require 'ucb_ccls_engine_factory_test_helper'
	require 'pending'
	require 'declarative'
	require 'no_access_without_login'
	require 'no_access_with_login'
	require 'access_without_login'
	require 'access_with_login'
	require 'access_with_https'
	require 'access_with_http'
	require 'no_access_with_http'
	require 'requires_valid_associations'
	require 'should_act_as_list'
	require 'should_associate'
	require 'should_require'
#	require 'ucb_ccls_engine_assertions'
end



#       %a - The abbreviated weekday name (``Sun'')
#       %A - The  full  weekday  name (``Sunday'')
#       %b - The abbreviated month name (``Jan'')
#       %B - The  full  month  name (``January'')
#       %c - The preferred local date and time representation
#       %d - Day of the month (01..31)
#       %H - Hour of the day, 24-hour clock (00..23)
#       %I - Hour of the day, 12-hour clock (01..12)
#       %j - Day of the year (001..366)
#       %m - Month of the year (01..12)
#       %M - Minute of the hour (00..59)
#       %p - Meridian indicator (``AM''  or  ``PM'')
#       %S - Second of the minute (00..60)
#       %U - Week  number  of the current year,
#               starting with the first Sunday as the first
#               day of the first week (00..53)
#       %W - Week  number  of the current year,
#               starting with the first Monday as the first
#               day of the first week (00..53)
#       %w - Day of the week (Sunday is 0, 0..6)
#       %x - Preferred representation for the date alone, no time
#       %X - Preferred representation for the time alone, no date
#       %y - Year without a century (00..99)
#       %Y - Year with century
#       %Z - Time zone name

Time::DATE_FORMATS[:mdy] = "%b %d, %Y"   # Jan 01, 2009
Date::DATE_FORMATS[:dob] = "%m/%d/%Y"   # 01/01/2009
Time::DATE_FORMATS[:filename] = "%Y%m%d%H%M%S"   # 20091231235959

