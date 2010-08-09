require File.dirname(__FILE__) + '/../test_helper'

class Ccls::RolesControllerTest < ActionController::TestCase
	tests RolesController

%w( admin ).each do |cu|

	test "should update with #{cu} login" do
		login_as send(cu)
		u = active_user
		assert !u.reload.role_names.include?('employee')
		assert_difference("User.find(#{u.id}).roles.length",1){
			put :update, :user_id => u.id, :id => 'employee'
		}
		assert  u.reload.role_names.include?('employee')
		assert_not_nil flash[:notice]
		assert_redirected_to user_path(assigns(:user))
	end

	test "should destroy with #{cu} login" do
		login_as send(cu)
		u = active_user
		u.roles << Role.find_or_create_by_name('employee')
		assert  u.reload.role_names.include?('employee')
		assert_difference("User.find(#{u.id}).roles.length",-1){
			delete :destroy, :user_id => u.id, :id => 'employee'
		}
		assert !u.reload.role_names.include?('employee')
		assert_not_nil flash[:notice]
		assert_redirected_to user_path(assigns(:user))
	end

	test "should NOT update without valid user_id with #{cu} login" do
		login_as send(cu)
		put :update, :user_id => 0, :id => 'employee'
		assert_not_nil flash[:error]
		assert_redirected_to users_path
	end

	test "should NOT destroy without valid user_id with #{cu} login" do
		login_as send(cu)
		delete :destroy, :user_id => 0, :id => 'employee'
		assert_not_nil flash[:error]
		assert_redirected_to users_path
	end

	test "should NOT update without user_id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			put :update, :id => 'employee'
		}
	end

	test "should NOT destroy without user_id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			delete :destroy, :id => 'employee'
		}
	end

	test "should NOT update self with #{cu} login" do
		u = send(cu)
		login_as u
		assert_difference("User.find(#{u.id}).roles.length",0){
			put :update, :user_id => u.id, :id => 'employee'
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
			delete :destroy, :user_id => u.id, :id => 'employee'
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

%w( moderator employee editor active_user ).each do |cu|

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
