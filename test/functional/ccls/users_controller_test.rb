require File.dirname(__FILE__) + '/../../test_helper'

class Ccls::UsersControllerTest < ActionController::TestCase
	tests UsersController

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

	assert_access_with_login({ 
		:logins => [:super_user,:admin] })
	assert_no_access_with_login({ 
		:logins => [:interviewer,:editor,:reader,:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

#	use full role names as used in one test method
%w( superuser administrator ).each do |cu|

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

%w( super_user admin editor interviewer reader active_user ).each do |cu|

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











#	We are using UCB CAS for authentication so this is unused.
#	If Authlogic or other is reused, uncomment all this.
#
#	#	not really a controller test
#	test "should NOT automatically log in new user with my helper" do
#		assert_difference('User.count',1) do
#			active_user
#		end
#		assert_equal Hash.new, session
#		assert_nil UserSession.find
#	end
#
#	#	not really a controller test
#	test "should NOT automatically log in new user with create" do
#		assert_difference('User.count',1) do
#			User.create(Factory.attributes_for(:user))
#		end
#		assert_equal Hash.new, session
#		assert_nil UserSession.find
#	end
#
#	test "should get new user without login" do
#		ui = Factory(:user_invitation)
#		get :new, :token => ui.token
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT get new user without invitation token" do
#		get :new
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT get new user without existing invitation token" do
#		get :new, :token => 'blah blah blah'
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT get new user without unused invitation token" do
#		ui = Factory(:user_invitation,:recipient_id => 0)
#		get :new, :token => ui.token
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT get new user with expired invitation token" do
#		pending
##		ui = Factory(:user_invitation,:recipient_id => 0)
##		get :new, :token => ui.token
##		assert_not_nil flash[:error]
##		assert_redirected_to root_path
#	end
#
#	test "should NOT get new user with login" do
#		ui = Factory(:user_invitation)
#		login_as user
#		get :new, :token => ui.token
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#
#	test "should create new user without login" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',1) {
#			post :create, :user => Factory.attributes_for(:user),
#				:token => ui.token
#		}
#		assert_not_nil flash[:notice]
#		assert_redirected_to_login
#	end
#
#	test "should mark invitation as used after use" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',1) {
#			post :create, :user => Factory.attributes_for(:user),
#				:token => ui.token
#		}
#		ui.reload
#		assert_not_nil ui.recipient_id
#		assert_not_nil ui.accepted_at
#		assert_equal ui.recipient_id, assigns(:user).id
#	end
#
#	test "should NOT create new user if invitation update fails" do
#		#
#		#	Nest transactions and savepoints don't work with SQLite
#		#	or with jruby database adapters
#		#	so testing User creation and UserInvitation validation
#		#	can't really be done.  This test is the outer transaction
#		#	so the rollback triggered by the failure doesn't occur 
#		#	until after the completion of the test.
#		#
#		#	Actually, by manually rolling back
#		#	I think that I am breaking the outer transaction
#		#	making testing the controller transaction possible.
#		#	I don't know how kosher this is and I'm actually
#		#	surprised that it works as I haven't read it anywhere.
#		#	Doing this with Sqlite and MySQL both with and
#		#	without jruby and all seem to work.
#		#
#		#	break the outer transaction
#		User.connection.rollback_db_transaction
#		User.connection.decrement_open_transactions
#		ui = Factory(:user_invitation)
#		UserInvitation.any_instance.stubs(:create_or_update).returns(false)
#		assert_difference('User.count',0) do
#			post :create, :user => Factory.attributes_for(:user),
#				:token => ui.token
#		end
#		assert_nil ui.recipient_id
#		assert_nil ui.accepted_at
#		#	killed test transaction so need to cleanup after self
#		ui.sender.destroy
#		ui.destroy
#	end
#
#	test "should NOT create new user with expired invitation token" do
##		ui = Factory(:user_invitation, :recipient_id => 0)
##		assert_difference('User.count',0) {
##			post :create, :user => Factory.attributes_for(:user),
##				:token => ui.token
##		}
##		assert_not_nil flash[:error]
##		assert_redirected_to root_path
#		pending
#	end
#
#	test "should NOT create new user without unused invitation token" do
#		ui = Factory(:user_invitation, :recipient_id => 0)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user),
#				:token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT create new user without existing invitation token" do
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user),
#				:token => 'blah blah blah'
#		}
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT create new user with login" do
#		ui = Factory(:user_invitation)
#		login_as user
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user), 
#				:token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT create new user without username" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:username => nil), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without unique username" do
#		ui = Factory(:user_invitation)
#		u = active_user
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:username => u.username), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without complex password" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:password              => 'mybigbadpassword',
#				:password_confirmation => 'mybigbadpassword'
#			), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without password" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:password => nil), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without password confirmation" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:password_confirmation => nil), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without matching password and confirmation" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:password => 'alpha',
#				:password_confirmation => 'beta'), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without email" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:email => nil), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without formatted email" do
#		ui = Factory(:user_invitation)
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:email => 'blah blah blah'), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#	test "should NOT create new user without unique email" do
#		ui = Factory(:user_invitation)
#		u = active_user
#		assert_difference('User.count',0) {
#			post :create, :user => Factory.attributes_for(:user,
#				:email => u.email), :token => ui.token
#		}
#		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'new'
#	end
#
#
#
#	test "should edit user with admin login" do
#		u = user
#		login_as admin
#		get :edit, :id => u.id
#		assert_response :success
#		assert_template 'edit'
#	end
#
#	test "should edit user with self login" do
#		u = user
#		login_as u
#		get :edit, :id => u.id
#		assert_response :success
#		assert_template 'edit'
#	end
#
#	test "should NOT edit user with just user login" do
#		u = user
#		login_as user
#		get :edit, :id => u.id
#		assert_redirected_to root_path
#		assert_not_nil flash[:error]
#	end
#
#	test "should NOT edit user without login" do
#		u = user
#		get :edit, :id => u.id
#		assert_redirected_to_login
#		assert_not_nil flash[:error]
#	end
#
#	test "should NOT edit user without valid id" do
#		u = user
#		login_as admin
#		get :edit, :id => 0
#		assert_redirected_to users_path
#		assert_not_nil flash[:error]
#	end
#
#	test "should NOT edit user without id" do
#		u = user
#		login_as admin
#		assert_raise(ActionController::RoutingError){
#			get :edit
#		}
#	end
#
#
#
#
#	test "should update user with self login" do
#		u = user
#		login_as u
#		put :update, :id => u.id, :user => Factory.attributes_for(:user)
#		assert_redirected_to root_path
#		assert_not_nil flash[:notice]
#	end
#
#	test "should update user with admin login" do
#		u = user
#		login_as admin
#		put :update, :id => u.id, :user => Factory.attributes_for(:user)
#		assert_redirected_to root_path
#		assert_not_nil flash[:notice]
#	end
#
#	test "should NOT update user with just login" do
#		u = user
#		login_as user
#		put :update, :id => u.id, :user => Factory.attributes_for(:user)
#		assert_redirected_to root_path
#		assert_not_nil flash[:error]
#	end
#
#	test "should NOT update user without login" do
#		u = user
#		put :update, :id => u.id, :user => Factory.attributes_for(:user)
#		assert_redirected_to_login
#		assert_not_nil flash[:error]
#	end
#
#	test "should NOT update user without valid id" do
#		u = user
#		login_as admin
#		put :update, :id => 0, :user => Factory.attributes_for(:user)
#		assert_redirected_to users_path
#		assert_not_nil flash[:error]
#	end
#
#	test "should NOT update user without id" do
#		u = user
#		login_as admin
#		assert_raise(ActionController::RoutingError){
#			put :update, :user => Factory.attributes_for(:user)
#		}
#	end
#
#	test "should update user without user" do
#		# kinda pointless
#		u = user
#		login_as admin
#		put :update, :id => u.id
#		assert_redirected_to root_path
#		assert_not_nil flash[:notice]
#	end
#
#	test "should NOT update user without username" do
#		u = user
#		login_as admin
#		put :update, :id => u.id, :user => Factory.attributes_for(:user,
#			:username => nil)
#		assert_response :success
#		assert_template 'edit'
#		assert_not_nil flash[:error]
#	end
#
#	test "should NOT update user without unique username" do
#		u1 = Factory(:user)
#		u = user
#		login_as admin
#		put :update, :id => u.id, :user => Factory.attributes_for(:user,
#			:username => u1.username)
#		assert_response :success
#		assert_template 'edit'
#		assert_not_nil flash[:error]
#	end
#
#	test "should update user without password" do
#		#	again odd.  Having password confirmation ignored.
#		u = user
#		login_as admin
#		put :update, :id => u.id, :user => Factory.attributes_for(:user,
#			:password => nil)
#		assert_redirected_to root_path
#	end
#
#	test "should NOT update user without complex password" do
#		u = user
#		login_as admin
#		put :update, :id => u.id, :user => Factory.attributes_for(:user,
#			:password              => 'mybigbadpassword',
#			:password_confirmation => 'mybigbadpassword')
#		assert_response :success
#		assert_template 'edit'
#		assert_not_nil flash[:error]
#	end
#
#	test "should NOT update user without matching password and confirmation" do
#		u = user
#		login_as admin
#		put :update, :id => u.id, :user => Factory.attributes_for(:user,
#			:password => 'alphaV@1!d', 
#			:password_confirmation => 'betaV@1!d')
#		assert_response :success
#		assert_template 'edit'
#		assert_not_nil flash[:error]
#	end
#
#	test "should NOT update user without password confirmation" do
#		u = user
#		login_as admin
#		put :update, :id => u.id, :user => Factory.attributes_for(:user,
#			:password_confirmation => nil)
#		assert_response :success
#		assert_template 'edit'
#		assert_not_nil flash[:error]
#	end





#	Destroy  


end
