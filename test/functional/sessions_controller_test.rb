require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

	test "should logout if authenticated" do
		login_as Factory(:user)
		assert_logged_in
		delete :destroy
		assert_redirected_to_logout
	end

	test "should NOT logout if NOT authenticated" do
		assert_not_logged_in
		delete :destroy
		assert_redirected_to_login
	end

#
#	A temp testing route :show was created specifically to 
#	test the current_user and logged_in? methods.  Without
#	actually making a request, these methods fail as the
#	session is nil.  When making a :destroy request, it is
#	destroyed and can't be checked.
#
#	I suppose that I could create a new controller that
#	doesn't meddle with the session, but ...
#

#	test "should not be logged_in? without login" do
#		assert_not_logged_in
#		get :show
#		assert_not_logged_in
#		assert_equal false, @controller.logged_in?
#		assert_redirected_to_login
#	end
#
#	test "should be logged_in? with login" do
#		assert_not_logged_in
#		login_as Factory(:user)
#		assert_logged_in
#		get :show
#		assert_logged_in
#		assert_equal true, @controller.logged_in?
#		assert_redirected_to '/'
#	end
#
#	test "should not have current_user without login" do
#		assert_not_logged_in
#		get :show
#		assert_not_logged_in
#		assert_nil @controller.current_user
#		assert_redirected_to_login
#	end
#
#	test "should have a current_user with login" do
#		assert_not_logged_in
#		login_as Factory(:user)
#		assert_logged_in
#		get :show
#		assert_logged_in
#		assert_not_nil @controller.current_user
#		assert @controller.current_user.is_a?(User)
#		assert @controller.current_user.is_a?(CalnetAuthenticatedUser())
#		assert_redirected_to '/'
#	end

end
