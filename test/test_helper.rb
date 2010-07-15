ENV["RAILS_ENV"] = "test"
require 'test/unit'			#	NEED THIS OR THE TESTS DON'T ACTUALLY EXECUTE
require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require 'action_controller'
require 'action_mailer'

#require File.dirname(__FILE__) + '/../rails/init.rb' 

#	http://guides.rubyonrails.org/plugins.html

#require File.dirname(__FILE__) + '/config/boot'
require File.dirname(__FILE__) + '/config/environment'
require 'test_help'

require 'factories'
require 'factory_test_helper'

def setup_db
	ActiveRecord::Migrator.migrate("db/migrate/",nil)
end

def teardown_db
	ActiveRecord::Migrator.migrate("db/migrate/",0)
end

class ActiveSupport::TestCase
	self.fixture_path = File.dirname(__FILE__) + "/fixtures/"
	fixtures :all
end


class ActionController::TestCase

	setup :turn_https_on

	def turn_https_on
		@request.env['HTTPS'] = 'on'
#		@request.env['HTTP_X_FORWARDED_PROTO'] == 'https'
	end

	def turn_https_off
		@request.env['HTTPS'] = nil
	end

	def assert_layout(layout)
		layout = "layouts/#{layout}" unless layout.match(/^layouts/)
		assert_equal layout, @response.layout
	end

end


setup_db()
