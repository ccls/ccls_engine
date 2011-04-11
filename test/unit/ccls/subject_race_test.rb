require 'test_helper'

class SubjectRaceTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_initially_belong_to( :subject )
	assert_should_initially_belong_to( :race )
end
