require 'test_helper'

class IcfMasterIdTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_belong_to(:study_subject)

	test "should return icf_master_id as to_s" do
		object = create_object(:icf_master_id => '123456789')
		assert_equal "#{object.icf_master_id}", "#{object}"
		assert_equal "123456789", "#{object}"
	end

end
