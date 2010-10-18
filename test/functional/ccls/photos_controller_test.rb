require File.dirname(__FILE__) + '/../../test_helper'

class Ccls::PhotosControllerTest < ActionController::TestCase
	tests PhotosController

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Photo',
		:actions => [:new,:create,:edit,:update,:destroy,:show,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create(options={})
		Factory(:photo,options)
	end
	def factory_attributes(options={})
		Factory.attributes_for(:photo,options)
	end

	assert_access_with_https
	assert_access_with_login({
		:logins => [:super_user,:admin,:editor]})

	assert_no_access_with_http 
	assert_no_access_with_login({ 
		:logins => [:interviewer,:reader,:active_user] })
	assert_no_access_without_login

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :super_user,
		:redirect => :photos_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:destroy => { :id => 0 }
	)

%w( super_user admin editor ).each do |cu|

	test "should NOT create invalid photo with #{cu} login" do
		login_as send(cu)
		assert_no_difference('Photo.count') do
			post :create, :photo => {}
		end
		assert_not_nil flash[:error]
		assert_template 'new'
		assert_response :success
	end

	test "should NOT update invalid photo with #{cu} login" do
		login_as send(cu)
		put :update, :id => factory_create.id, 
			:photo => { :title => "a" }
		assert_not_nil flash[:error]
		assert_template 'edit'
		assert_response :success
	end

end

end
