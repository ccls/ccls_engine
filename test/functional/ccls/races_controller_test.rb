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

	assert_access_with_login(    :logins => site_administrators )
	assert_no_access_with_login( :logins => non_site_administrators )
	assert_no_access_without_login
	assert_access_with_https
	assert_no_access_with_http

end
