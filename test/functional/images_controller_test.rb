require File.dirname(__FILE__) + '/../test_helper'

class ImagesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Image',
		:actions => [:new,:create,:edit,:update,:destroy,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create
		Factory(:image)
	end
	def factory_attributes
		Factory.attributes_for(:image)
	end

	assert_access_with_http :show, { :actions => nil }
	assert_access_with_login(:show,{
		:logins => [:moderator,:employee,:active_user], :actions => nil})
	assert_access_without_login( :show, { :actions => nil })

	assert_access_with_https :show
	assert_access_with_login(:show,{
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

end
