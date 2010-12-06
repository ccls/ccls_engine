require File.dirname(__FILE__) + '/../test_helper'

class HomeExposureResponseTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:subject)
	assert_should_require_unique_attribute(:study_subject_id)

end
