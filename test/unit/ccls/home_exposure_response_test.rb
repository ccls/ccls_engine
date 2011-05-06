require 'test_helper'

class Ccls::HomeExposureResponseTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:subject)
	assert_should_require_unique_attribute(:study_subject_id)

	test "should return array of field_names" do
		field_names = HomeExposureResponse.field_names
		assert field_names.is_a?(Array)
		assert field_names.length > 100
	end

	assert_should_not_require_attributes( *HomeExposureResponse.field_names )

end
