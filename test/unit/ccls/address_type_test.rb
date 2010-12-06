require File.dirname(__FILE__) + '/../test_helper'

class AddressTypeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes(:code)
	assert_should_require_unique_attributes(:code)
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :description )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :code, :minimum => 4 )
		o.assert_should_require_attribute_length( :description )
	end
	assert_should_act_as_list
	assert_should_have_many(:addresses)

	test "should return code as to_s" do
		object = create_object
		assert_equal object.code, "#{object}"
	end

	test "should find by code with ['string']" do
		object = AddressType['residence']
		assert object.is_a?(AddressType)
	end

	test "should find by code with [:symbol]" do
		object = AddressType[:residence]
		assert object.is_a?(AddressType)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(AddressType::NotFound) {
#			object = AddressType['idonotexist']
#		}
#	end

end
