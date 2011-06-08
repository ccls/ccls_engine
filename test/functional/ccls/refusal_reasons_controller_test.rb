require 'test_helper'

class Ccls::RefusalReasonsControllerTest < ActionController::TestCase
	tests RefusalReasonsController

	ASSERT_ACCESS_OPTIONS = {
		:model => 'RefusalReason',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_refusal_reason
	}
	def factory_attributes(options={})
		Factory.attributes_for(:refusal_reason,options)
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
		:redirect => :refusal_reasons_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	)

	site_administrators.each do |cu|

		test "should NOT create new refusal_reason with #{cu} login when create fails" do
			RefusalReason.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			assert_difference('RefusalReason.count',0) do
				post :create, :refusal_reason => factory_attributes
			end
			assert assigns(:refusal_reason)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT create new refusal_reason with #{cu} login and invalid refusal_reason" do
			RefusalReason.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			assert_difference('RefusalReason.count',0) do
				post :create, :refusal_reason => factory_attributes
			end
			assert assigns(:refusal_reason)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT update refusal_reason with #{cu} login when update fails" do
			refusal_reason = create_refusal_reason(:updated_at => Chronic.parse('yesterday'))
			RefusalReason.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			deny_changes("RefusalReason.find(#{refusal_reason.id}).updated_at") {
				put :update, :id => refusal_reason.id,
					:refusal_reason => factory_attributes
			}
			assert assigns(:refusal_reason)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

		test "should NOT update refusal_reason with #{cu} login and invalid refusal_reason" do
			refusal_reason = create_refusal_reason(:updated_at => Chronic.parse('yesterday'))
			RefusalReason.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			deny_changes("RefusalReason.find(#{refusal_reason.id}).updated_at") {
				put :update, :id => refusal_reason.id,
					:refusal_reason => factory_attributes
			}
			assert assigns(:refusal_reason)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

	end

end
