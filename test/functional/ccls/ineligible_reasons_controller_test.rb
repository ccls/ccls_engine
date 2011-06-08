require 'test_helper'

class Ccls::IneligibleReasonsControllerTest < ActionController::TestCase
	tests IneligibleReasonsController

	ASSERT_ACCESS_OPTIONS = {
		:model => 'IneligibleReason',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_ineligible_reason
	}
	def factory_attributes(options={})
		Factory.attributes_for(:ineligible_reason,options)
	end

	assert_access_with_login(    :logins => site_administrators )
	assert_no_access_with_login( :logins => non_site_administrators )
	assert_no_access_without_login
	assert_access_with_https
	assert_no_access_with_http

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :ineligible_reasons_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	)

	site_administrators.each do |cu|

		test "should NOT create new ineligible_reason with #{cu} login when create fails" do
			IneligibleReason.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			assert_difference('IneligibleReason.count',0) do
				post :create, :ineligible_reason => factory_attributes
			end
			assert assigns(:ineligible_reason)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT create new ineligible_reason with #{cu} login and invalid ineligible_reason" do
			IneligibleReason.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			assert_difference('IneligibleReason.count',0) do
				post :create, :ineligible_reason => factory_attributes
			end
			assert assigns(:ineligible_reason)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT update ineligible_reason with #{cu} login when update fails" do
			ineligible_reason = create_ineligible_reason(:updated_at => Chronic.parse('yesterday'))
			IneligibleReason.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			deny_changes("IneligibleReason.find(#{ineligible_reason.id}).updated_at") {
				put :update, :id => ineligible_reason.id,
					:ineligible_reason => factory_attributes
			}
			assert assigns(:ineligible_reason)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

		test "should NOT update ineligible_reason with #{cu} login and invalid ineligible_reason" do
			ineligible_reason = create_ineligible_reason(:updated_at => Chronic.parse('yesterday'))
			IneligibleReason.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			deny_changes("IneligibleReason.find(#{ineligible_reason.id}).updated_at") {
				put :update, :id => ineligible_reason.id,
					:ineligible_reason => factory_attributes
			}
			assert assigns(:ineligible_reason)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

	end

end
