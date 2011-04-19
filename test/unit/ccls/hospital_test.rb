require 'test_helper'

class Ccls::HospitalTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_belong_to(:organization)
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :organization_id )

	test "should return organization name as to_s if organization" do
		organization = create_organization
		hospital = create_hospital(:organization => organization)
		assert_not_nil hospital.organization
		assert_equal organization.name, "#{hospital}"
	end

	test "should return Unknown as to_s if no organization" do
		hospital = create_hospital
		assert_nil hospital.organization
		assert_equal 'Unknown', "#{hospital}"
	end

end
