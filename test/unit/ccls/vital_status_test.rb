require 'test_helper'

class Ccls::VitalStatusTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :study_subjects )
	assert_should_require_attributes( :key, :code, :description )
	assert_should_require_unique_attributes( :key, :code, :description )
	assert_should_not_require_attributes( :position )

	assert_should_require_attribute_length( :description, :in => 4..250 )
	assert_should_require_attribute_length( :key, :maximum => 250 )

	test "should return description as to_s" do
		vital_status = create_vital_status
		assert_equal vital_status.description, "#{vital_status}"
	end

	test "should find by key with ['string']" do
		vital_status = VitalStatus['living']
		assert vital_status.is_a?(VitalStatus)
	end

	test "should find by key with [:symbol]" do
		vital_status = VitalStatus[:living]
		assert vital_status.is_a?(VitalStatus)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(VitalStatus::NotFound) {
#			vital_status = VitalStatus['idonotexist']
#		}
#	end

protected

	def create_vital_status(options={})
		vital_status = Factory.build(:vital_status,options)
		vital_status.save
		vital_status
	end

end
