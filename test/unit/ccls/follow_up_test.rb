require 'test_helper'

class Ccls::FollowUpTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_initially_belong_to(:section,:enrollment,:follow_up_type)
end
