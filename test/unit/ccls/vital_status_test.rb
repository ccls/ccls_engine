require File.dirname(__FILE__) + '/../test_helper'

class VitalStatusTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :subjects )
	assert_should_require_attributes( :code )
	assert_should_require_attributes( :description )
	assert_should_require_unique_attributes( :code )
	assert_should_not_require_attributes( :position )
	assert_should_require_attribute_length( :description, :minimum => 4, :maximum => 250 )

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

#	test "should find by code with ['string']" do
#		object = VitalStatus['living']
#		assert object.is_a?(VitalStatus)
#	end
#
#	test "should find by code with [:symbol]" do
#		object = VitalStatus[:living]
#		assert object.is_a?(VitalStatus)
#	end
#
#	test "should raise error if not found by code with []" do
#		assert_raise(VitalStatus::NotFound) {
#			object = VitalStatus['idonotexist']
#		}
#	end

end
