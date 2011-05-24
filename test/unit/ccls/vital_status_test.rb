require 'test_helper'

class Ccls::VitalStatusTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :subjects )
	assert_should_require_attributes( :key )
	assert_should_require_attributes( :code )
	assert_should_require_attributes( :description )
	assert_should_require_unique_attributes( :key )
	assert_should_require_unique_attributes( :code )
	assert_should_require_unique_attributes( :description )
	assert_should_not_require_attributes( :position )

	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :description, :minimum => 4)
		o.assert_should_require_attribute_length( :key )
#		o.assert_should_require_attribute_length( :code )
	end

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

	test "should find by key with ['string']" do
		object = VitalStatus['living']
		assert object.is_a?(VitalStatus)
	end

	test "should find by key with [:symbol]" do
		object = VitalStatus[:living]
		assert object.is_a?(VitalStatus)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(VitalStatus::NotFound) {
#			object = VitalStatus['idonotexist']
#		}
#	end

end
