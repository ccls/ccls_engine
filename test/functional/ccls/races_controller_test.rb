require 'test_helper'

class Ccls::RacesControllerTest < ActionController::TestCase
	tests RacesController

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Race',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_race
	}
	def factory_attributes(options={})
		Factory.attributes_for(:race,options)
	end

	assert_access_with_login({ 
		:logins => [:superuser,:admin] })
	assert_no_access_with_login({ 
		:logins => [:editor,:interviewer,:reader,:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :races_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	)

%w( superuser admin ).each do |cu|

	test "should NOT create new race with #{cu} login when create fails" do
		Race.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		assert_difference('Race.count',0) do
			post :create, :race => factory_attributes
		end
		assert assigns(:race)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create new race with #{cu} login and invalid race" do
		Race.any_instance.stubs(:valid?).returns(false)
		login_as send(cu)
		assert_difference('Race.count',0) do
			post :create, :race => factory_attributes
		end
		assert assigns(:race)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT update race with #{cu} login when update fails" do
		race = create_race(:updated_at => Chronic.parse('yesterday'))
		Race.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		deny_changes("Race.find(#{race.id}).updated_at") {
			put :update, :id => race.id,
				:race => factory_attributes
		}
		assert assigns(:race)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update race with #{cu} login and invalid race" do
		race = create_race(:updated_at => Chronic.parse('yesterday'))
		Race.any_instance.stubs(:valid?).returns(false)
		login_as send(cu)
		deny_changes("Race.find(#{race.id}).updated_at") {
			put :update, :id => race.id,
				:race => factory_attributes
		}
		assert assigns(:race)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

end

end
