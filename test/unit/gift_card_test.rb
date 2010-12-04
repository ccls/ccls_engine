require File.dirname(__FILE__) + '/../test_helper'

class GiftCardTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_belong_to(:subject)
	assert_should_belong_to(:project)
	assert_should_require_attributes(:number)
	assert_should_require_unique_attributes(:number)
	assert_should_not_require_attributes( :study_subject_id )
	assert_should_not_require_attributes( :project_id )
	assert_should_not_require_attributes( :issued_on )
	assert_should_not_require_attributes( :expiration )
	assert_should_not_require_attributes( :vendor )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :expiration )
		o.assert_should_require_attribute_length( :vendor )
		o.assert_should_require_attribute_length( :number )
	end

	test "should return number as to_s" do
		object = create_object
		assert_equal object.number, "#{object}"
	end

end
