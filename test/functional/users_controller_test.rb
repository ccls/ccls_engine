require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'User',
		:actions => [:destroy,:index,:show],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}

	def factory_attributes
		Factory.attributes_for(:user)
	end
	def factory_create
		Factory(:user)
	end

	assert_access_with_login(    :logins => site_administrators )
	assert_no_access_with_login( :logins => non_site_administrators )
	assert_no_access_without_login
	assert_access_with_https
	assert_no_access_with_http

	#	use full role names as used in one test method
	site_administrators.each do |cu|
	
		test "should filter users index by role with #{cu} login" do
			some_other_user = send(cu)
			login_as send(cu)
			get :index, :role_name => cu
			assert assigns(:users).length >= 2
			assigns(:users).each do |u|
				assert u.role_names.include?(cu)
			end
			assert_nil flash[:error]
			assert_response :success
		end
	
		test "should ignore empty role_name with #{cu} login" do
			some_other_user = admin
			login_as send(cu)
			get :index, :role_name => ''
			assert assigns(:users).length >= 2
			assert_nil flash[:error]
			assert_response :success
		end
	
		test "should ignore invalid role with #{cu} login" do
			login_as send(cu)
			get :index, :role_name => 'suffocator'
	#		assert_not_nil flash[:error]
			assert_response :success
		end
	
		test "should get private users menu via js with #{cu} login" do
			login_as send(cu)
			@request.accept = "text/javascript"
			get :menu
			assert_response :success
			assert_match /jQuery/, @response.body
		end
	
	end
	
	all_test_roles.each do |cu|
	
		test "should NOT get user info with invalid id with #{cu} login" do
			login_as send(cu)
			get :show, :id => 0
			assert_not_nil flash[:error]
			assert_redirected_to users_path
		end
	
		test "should get #{cu} info with self login" do
			u = send(cu)
			login_as u
			get :show, :id => u.id
			assert_response :success
			assert_not_nil assigns(:user)
			assert_equal u, assigns(:user)
		end
	
	end

	test "should get empty private users menu via js without login" do
		@request.accept = "text/javascript"
		get :menu
		assert_response :success
		assert_match /\A\s*\z/, @response.body
	end

end
