require 'test_helper'

class Ccls::HomeExposureResponseTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:subject)
	assert_should_require_unique_attribute(:study_subject_id)
	assert_should_not_require_attributes( :consent_read_over_phone )
	assert_should_not_require_attributes( :respondent_requested_new_consent )
	assert_should_not_require_attributes( :consent_reviewed_with_respondent )

	test "should return array of field_names" do
		field_names = HomeExposureResponse.field_names
		assert field_names.is_a?(Array)
		assert field_names.length > 100
	end

end
