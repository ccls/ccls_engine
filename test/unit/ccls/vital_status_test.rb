require 'test_helper'

class Ccls::VitalStatusTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :study_subjects )
#	assert_should_require_attributes( :code )
#	assert_should_require_unique_attributes( :code )
	assert_should_not_require_attributes( :position )

	test "explicit Factory vital_status test" do
		assert_difference('VitalStatus.count',1) {
			vital_status = Factory(:vital_status)
			assert_match /key\d*/,  vital_status.key
#			assert_match /\d*/,     vital_status.code.to_s
			assert_match /Desc\d*/, vital_status.description
		}
	end

	test "should return description as to_s" do
		vital_status = create_vital_status
		assert_equal vital_status.description, "#{vital_status}"
	end

#protected
#
#	def create_vital_status(options={})
#		vital_status = Factory.build(:vital_status,options)
#		vital_status.save
#		vital_status
#	end

end
