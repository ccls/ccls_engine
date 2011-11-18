require 'test_helper'

class Ccls::ZipCodesControllerTest < ActionController::TestCase
	tests ZipCodesController

	ASSERT_ACCESS_OPTIONS = {
		:model => 'ZipCode',
		:actions => [:index],
		:method_for_create => :create_zip_code
	}

	assert_access_with_login( :logins => all_test_roles )
	assert_access_without_login
	assert_access_with_https
	assert_no_access_with_http

	test "should only get 10 zip_codes" do
		get :index
		assert_response :success
		assert_template 'index'
		assert_equal 10, assigns(:zip_codes).length
	end

end
