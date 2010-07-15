require 'authlogic/test_case'
class ActionController::TestCase
	setup :activate_authlogic
end

class ActiveSupport::TestCase

	def login_as( user )
		u = User.find(user)
		UserSession.create(u)
	end
	alias :login  :login_as
	alias :log_in :login_as

	def assert_redirected_to_login
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	def assert_redirected_to_logout
		assert_redirected_to logout_path
	end

	def assert_logged_in
		assert_not_nil UserSession.find
	end

	def assert_not_logged_in
		assert_nil UserSession.find
	end

end
