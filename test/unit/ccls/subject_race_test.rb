require 'test_helper'

class Ccls::SubjectRaceTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_initially_belong_to( :study_subject, :race )
end
