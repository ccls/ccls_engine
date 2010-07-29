ENV["RAILS_ENV"] = "test"

#	NEED THIS OR THE TESTS DON'T ACTUALLY EXECUTE
#	I don't understand why it isn't here by default.
require 'test/unit'			

require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require 'action_controller'
require 'action_mailer'

require File.dirname(__FILE__) + '/config/environment'
require 'test_help'

class ActiveSupport::TestCase
	self.fixture_path = File.dirname(__FILE__) + "/fixtures/"
	fixtures :all
end

class ActionController::TestCase

	setup :turn_https_on

	def turn_https_on
		@request.env['HTTPS'] = 'on'
	end

	def turn_https_off
		@request.env['HTTPS'] = nil
	end

	def assert_layout(layout)
		layout = "layouts/#{layout}" unless layout.match(/^layouts/)
		assert_equal layout, @response.layout
	end

end


ActiveRecord::Migrator.migrate("db/migrate/",nil)
ActiveRecord::Migrator.migrate("test/db/migrate/",nil)
