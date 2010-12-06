require File.dirname(__FILE__) + '/../test_helper'

class HospitalTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_belong_to(:organization)
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :organization_id )

end
