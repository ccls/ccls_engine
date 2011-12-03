require 'test_helper'

class Ccls::HospitalTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_initially_belong_to(:organization)
	assert_should_require_attributes_not_nil( :has_irb_waiver )
	assert_should_not_require_attributes( :position )
	assert_should_require_unique_attributes( :organization_id )

	test "explicit Factory hospital test" do
		assert_difference('Organization.count',1) {
		assert_difference('Hospital.count',1) {
			hospital = Factory(:hospital)
			assert_not_nil hospital.organization
			assert !hospital.has_irb_waiver	#	database default
		} }
	end

	test "explicit Factory nonwaivered hospital test" do
		assert_difference('Organization.count',1) {
		assert_difference('Hospital.count',1) {
			hospital = Factory(:nonwaivered_hospital)
			assert_not_nil hospital.organization
			assert !hospital.has_irb_waiver	#	database default
		} }
	end

	test "explicit Factory waivered hospital test" do
		assert_difference('Organization.count',1) {
		assert_difference('Hospital.count',1) {
			hospital = Factory(:waivered_hospital)
			assert_not_nil hospital.organization
			assert hospital.has_irb_waiver
		} }
	end

	test "should require organization" do
		assert_difference( "Hospital.count", 0 ) do
			hospital = create_hospital( :organization => nil)
			assert !hospital.errors.on(:organization)
			assert  hospital.errors.on_attr_and_type?(:organization_id,:blank)
		end
	end

	test "should require valid organization" do
		assert_difference( "Hospital.count", 0 ) do
			hospital = create_hospital( :organization_id => 0)
			assert !hospital.errors.on(:organization_id)
			assert  hospital.errors.on_attr_and_type?(:organization,:blank)
		end
	end

	test "should return organization name as to_s if organization" do
		organization = create_organization
		hospital = create_hospital(:organization => organization)
		assert_not_nil hospital.organization
		assert_equal organization.name, "#{hospital}"
	end

#	If organization is required, this can't ever happen
#	test "should return Unknown as to_s if no organization" do
#		hospital = create_hospital
#		assert_nil hospital.reload.organization
#		assert_equal 'Unknown', "#{hospital}"
#	end

	test "should return waivered hospitals" do
		hospitals = Hospital.waivered
		assert !hospitals.empty?
		assert_equal 22, hospitals.length	#	this is true now, but will change
		hospitals.each do |hospital|
			assert hospital.has_irb_waiver
		end
	end

	test "should return nonwaivered hospitals" do
		hospitals = Hospital.nonwaivered
		assert !hospitals.empty?
		#	the addition of the "unspecified" and "don't know" make this 5 now
		assert_equal 5, hospitals.length	#	this is true now, but will change
		hospitals.each do |hospital|
			assert !hospital.has_irb_waiver
		end
	end

#protected
#
#	def create_hospital(options={})
#		hospital = Factory.build(:hospital,options)
#		hospital.save
#		hospital
#	end
#
#	def create_organization(options={})
#		organization = Factory.build(:organization,options)
#		organization.save
#		organization
#	end

end
