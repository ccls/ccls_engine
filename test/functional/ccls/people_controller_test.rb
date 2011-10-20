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

end
