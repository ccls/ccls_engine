require File.dirname(__FILE__) + '/../../test_helper'

class SimplyAuthorized::RolesControllerTest < ActionController::TestCase
	tests RolesController

	#	no user_id
	assert_no_route(:put, :update, :id => 'reader')
	assert_no_route(:delete, :destroy, :id => 'reader')

%w( super_user admin ).each do |cu|

	test "should update with #{cu} login" do
		login_as send(cu)
		u = active_user
		assert !u.reload.role_names.include?('reader')
		assert_difference("User.find(#{u.id}).roles.length",1){
			put :update, :user_id => u.id, :id => 'reader'
		}
		assert  u.reload.role_names.include?('reader')
		assert_not_nil flash[:notice]
		assert_redirected_to user_path(assigns(:user))
	end

	test "should destroy with #{cu} login" do
		login_as send(cu)
		u = active_user
		u.roles << Role.find_or_create_by_name('reader')
		assert  u.reload.role_names.include?('reader')
		assert_difference("User.find(#{u.id}).roles.length",-1){
			delete :destroy, :user_id => u.id, :id => 'reader'
		}
		assert !u.reload.role_names.include?('reader')
		assert_not_nil flash[:notice]
		assert_redirected_to user_path(assigns(:user))
	end

	test "should NOT update without valid user_id with #{cu} login" do
		login_as send(cu)
		put :update, :user_id => 0, :id => 'reader'
		assert_not_nil flash[:error]
		assert_redirected_to users_path
	end

	test "should NOT destroy without valid user_id with #{cu} login" do
		login_as send(cu)
		delete :destroy, :user_id => 0, :id => 'reader'
		assert_not_nil flash[:error]
		assert_redirected_to users_path
	end

	test "should NOT update self with #{cu} login" do
		u = send(cu)
		login_as u
		assert_difference("User.find(#{u.id}).roles.length",0){
			put :update, :user_id => u.id, :id => 'reader'
		}
		assert_not_nil flash[:error]
		assert_equal u, assigns(:user)
		assert_redirected_to user_path(assigns(:user))
#		assert_redirected_to root_path
	end

	test "should NOT destroy self with #{cu} login" do
		u = send(cu)
		login_as u
		assert_difference("User.find(#{u.id}).roles.length",0){
			delete :destroy, :user_id => u.id, :id => 'reader'
		}
		assert_not_nil flash[:error]
		assert_equal u, assigns(:user)
		assert_redirected_to user_path(assigns(:user))
#		assert_redirected_to root_path
	end

	test "should NOT update without valid role_name with #{cu} login" do
		login_as send(cu)
		u = active_user
		assert_difference("User.find(#{u.id}).roles.length",0){
			put :update, :user_id => u.id, :id => 'bogus_role_name'
		}
		assert_not_nil flash[:error]
		assert_redirected_to user_path(assigns(:user))
	end

	test "should NOT destroy without valid role_name with #{cu} login" do
		login_as send(cu)
		u = active_user
		assert_difference("User.find(#{u.id}).roles.length",0){
			delete :destroy, :user_id => u.id, :id => 'bogus_role_name'
		}
		assert_not_nil flash[:error]
		assert_redirected_to user_path(assigns(:user))
	end

end

%w( interviewer reader editor active_user ).each do |cu|

	test "should NOT update with #{cu} login" do
		login_as send(cu)
		u = active_user
		assert !u.reload.role_names.include?('administrator')
		assert_difference("User.find(#{u.id}).roles.length",0){
			put :update, :user_id => u.id, :id => 'administrator'
		}
		assert !u.reload.role_names.include?('administrator')
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT destroy with #{cu} login" do
		login_as send(cu)
		u = active_user
		u.roles << Role.find_or_create_by_name('administrator')
		assert u.reload.role_names.include?('administrator')
		assert_difference("User.find(#{u.id}).roles.length",0){
			delete :destroy, :user_id => u.id, :id => 'administrator'
		}
		assert u.reload.role_names.include?('administrator')
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end

	test "should NOT update without login" do
		u = active_user
		assert_difference("User.find(#{u.id}).roles.length",0){
			put :update, :user_id => u.id, :id => 'administrator'
		}
		assert_redirected_to_login
	end

	test "should NOT destroy without login" do
		u = active_user
		assert_difference("User.find(#{u.id}).roles.length",0){
			delete :destroy, :user_id => u.id, :id => 'administrator'
		}
		assert_redirected_to_login
	end

end
