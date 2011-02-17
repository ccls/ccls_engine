require 'test_helper'

class Ccls::CalendarsControllerTest < ActionController::TestCase
	tests CalendarsController

	ASSERT_ACCESS_OPTIONS = { :actions => [:show] }

	assert_access_with_login({
		:logins => [:superuser,:admin,:editor,:interviewer,:reader] })
	assert_no_access_with_login({
		:logins => [:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

end
