require 'test_helper'

class Ccls::HospitalTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_belong_to(:organization)
#	assert_should_require_attributes( :has_irb_waiver )
	assert_should_require_attributes_not_nil( :has_irb_waiver )
	assert_should_not_require_attributes( :position, :organization_id )

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

protected

	def create_hospital(options={})
		hospital = Factory.build(:hospital,options)
		hospital.save
		hospital
	end

	def create_organization(options={})
		organization = Factory.build(:organization,options)
		organization.save
		organization
	end

end
