ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

$LOAD_PATH.unshift File.dirname(__FILE__) # NEEDED for rake test:coverage

class ActiveSupport::TestCase

	fixtures :all

end

class ActionController::TestCase

	setup :turn_https_on

end
