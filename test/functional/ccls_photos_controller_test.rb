require File.dirname(__FILE__) + '/../test_helper'

module Ccls
class PhotosControllerTest < ActionController::TestCase
	tests PhotosController

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Photo',
		:actions => [:new,:create,:edit,:update,:destroy,:show,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create
		Factory(:photo)
	end
	def factory_attributes
		Factory.attributes_for(:photo)
	end

	assert_access_with_https
	assert_access_with_login({
		:logins => [:admin,:editor]})

	assert_no_access_with_http 
	assert_no_access_with_login({ 
		:logins => [:moderator,:employee,:active_user] })
	assert_no_access_without_login

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :admin,
		:redirect => :photos_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:destroy => { :id => 0 }
	)

%w( admin editor ).each do |cu|

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
		put :update, :id => Factory(:photo).id, 
			:photo => { :title => "a" }
		assert_not_nil flash[:error]
		assert_template 'edit'
		assert_response :success
	end

end

end
end
