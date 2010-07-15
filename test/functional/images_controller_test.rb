require File.dirname(__FILE__) + '/../test_helper'

class ImagesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Image',
		:actions => [:new,:create,:edit,:update,:destroy,:show,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create
		Factory(:image)
	end
	def factory_attributes
		Factory.attributes_for(:image)
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
		:redirect => :images_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:destroy => { :id => 0 }
	)

%w( admin editor ).each do |cu|

	test "should NOT create invalid image with #{cu} login" do
		login_as send(cu)
		assert_no_difference('Image.count') do
			post :create, :image => {}
		end
		assert_not_nil flash[:error]
		assert_template 'new'
		assert_response :success
	end

	test "should NOT update invalid image with #{cu} login" do
		login_as send(cu)
		put :update, :id => Factory(:image).id, 
			:image => { :title => "a" }
		assert_not_nil flash[:error]
		assert_template 'edit'
		assert_response :success
	end

end

end
