require File.dirname(__FILE__) + '/../../test_helper'

class Ccls::UserInvitationsControllerTest < ActionController::TestCase
	tests UserInvitationsController

#	We are using UCB CAS for authentication so this is unused.
#	If Authlogic or other is reused, uncomment all this.
#
#	test "should NOT get new without login" do
#		get :new
#		assert_not_nil flash[:error]
#		assert_redirected_to_login
#		assert_nil assigns(:user_invitation)
#	end
#
#	test "should NOT get new with just user login" do
#		login_as user
#		get :new
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#		assert_nil assigns(:user_invitation)
#	end
#
#	test "should get new with admin login" do
#		login_as admin
#		get :new
#		assert_response :success
#		assert_template 'new'
#		assert_not_nil assigns(:user_invitation)
#	end
#
#	
#
#	test "should NOT create without login" do
#		assert_difference('UserInvitation.count',0) do
#			post :create, :user_invitation => Factory.attributes_for(
#				:user_invitation)
#		end
#		assert_not_nil flash[:error]
#		assert_redirected_to_login
#	end
#
#	test "should NOT create with just login" do
#		login_as user
#		assert_difference('UserInvitation.count',0) do
#			post :create, :user_invitation => Factory.attributes_for(
#				:user_invitation)
#		end
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT create with empty invitation" do
#		login_as admin
#		assert_difference('UserInvitation.count',0) do
#			post :create, :user_invitation => {}
#		end
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should create with admin login" do
#		login_as admin
#		assert_difference('UserInvitation.count',1) do
#			post :create, :user_invitation => Factory.attributes_for(
#				:user_invitation)
#		end
#		assert_not_nil flash[:notice]
#		assert_redirected_to root_path
#	end
#
#
#	test "should NOT show with login" do
#		login_as admin
#		get :show, :id => 0
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT show with invalid token / id" do
#		get :show, :id => 'some fake token'
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT show with expired token / id" do
#		pending
##		get :show, :id => 'some fake token'
##		assert_not_nil flash[:error]
##		assert_redirected_to root_path
#	end
#
#	test "should NOT show with used token / id" do
#		ui = Factory(:user_invitation,:recipient_id => 0)
#		get :show, :id => ui.token
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should show with invalid token / id" do
#		ui = Factory(:user_invitation)
#		get :show, :id => ui.token
##		assert_match new_user_path, @response.redirected_to
##		assert_match "token=#{ui.token}", @response.redirected_to
#		assert_redirected_to new_user_path(:token => ui.token)
#	end

end
