require 'test_helper'

class Ccls::AddressTypeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes(:code)
	assert_should_require_unique_attributes(:code)
	assert_should_not_require_attributes( :position, :description )
	assert_should_require_attribute_length( :code,        :in => 4..250 )
	assert_should_require_attribute_length( :description, :maximum => 250 )
	assert_should_act_as_list
	assert_should_have_many(:addresses)

	test "should return code as to_s" do
		address_type = Factory(:address_type)
		assert_equal address_type.code, "#{address_type}"
	end

	test "should find by code with ['string']" do
		address_type = AddressType['residence']
		assert address_type.is_a?(AddressType)
	end

	test "should find by code with [:symbol]" do
		address_type = AddressType[:residence]
		assert address_type.is_a?(AddressType)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(AddressType::NotFound) {
#			address_type = AddressType['idonotexist']
#		}
#	end

end
