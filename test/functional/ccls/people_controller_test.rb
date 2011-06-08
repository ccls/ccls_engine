require 'test_helper'

class Ccls::PeopleControllerTest < ActionController::TestCase
	tests PeopleController

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Person',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_person
	}
	def factory_attributes(options={})
		Factory.attributes_for(:person,options)
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
		:redirect => :people_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	)

	site_administrators.each do |cu|

		test "should NOT create new person with #{cu} login " <<
			"when create fails" do
			Person.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			assert_difference('Person.count',0) do
				post :create, :person => factory_attributes
			end
			assert assigns(:person)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT create new person with #{cu} login " <<
			"and invalid person" do
			login_as send(cu)
			Person.any_instance.stubs(:valid?).returns(false)
			assert_difference('Person.count',0) do
				post :create, :person => factory_attributes
			end
			assert assigns(:person)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT update person with #{cu} login " <<
			"when update fails" do
			person = create_person(:updated_at => Chronic.parse('yesterday'))
			Person.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			deny_changes("Person.find(#{person.id}).updated_at") {
				put :update, :id => person.id,
					:person => factory_attributes
			}
			assert assigns(:person)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

		test "should NOT update person with #{cu} login " <<
			"and invalid person" do
			person = create_person(:updated_at => Chronic.parse('yesterday'))
			Person.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			deny_changes("Person.find(#{person.id}).updated_at") {
				put :update, :id => person.id,
					:person => factory_attributes
			}
			assert assigns(:person)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

	end

end
