require 'test_helper'

class Ccls::GiftCardTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_belong_to(:subject, :project)
	assert_should_require_attributes(:number)
	assert_should_require_unique_attributes(:number)
	assert_should_not_require_attributes( :study_subject_id,
		:project_id,
		:issued_on,
		:expiration,
		:vendor )
	assert_should_require_attribute_length( :expiration,
		:vendor,
		:number, 
			:maximum => 250 )

	test "should return number as to_s" do
		object = create_object
		assert_equal object.number, "#{object}"
	end

#	Add search tests

	test "should search for stuff" do
pending
	end

end
