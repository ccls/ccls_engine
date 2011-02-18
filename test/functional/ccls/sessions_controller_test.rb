require 'test_helper'

class Ccls::SessionsControllerTest < ActionController::TestCase
	tests SessionsController

	test "should logout if authenticated" do
		login_as active_user
		assert_logged_in
		delete :destroy
		assert_redirected_to_logout
	end

	test "should NOT logout if NOT authenticated" do
		assert_not_logged_in
		delete :destroy
		assert_redirected_to_login
	end

end
