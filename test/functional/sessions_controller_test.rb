require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase

	test "should logout if authenticated" do
		login_as active_user
		delete :destroy
		assert_redirected_to_logout
	end

	test "should NOT logout if NOT authenticated" do
		delete :destroy
		assert_redirected_to_login
	end

end
