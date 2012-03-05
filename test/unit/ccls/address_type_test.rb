require 'test_helper'

class Ccls::AddressTypeTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_not_require_attributes( :position )
	assert_should_act_as_list
	assert_should_have_many(:addresses)

	test "explicit Factory address_type test" do
		assert_difference('AddressType.count',1) {
			address_type = Factory(:address_type)
			assert_match /Key\d*/,  address_type.key
			assert_match /Desc\d*/,  address_type.description
		}
	end

	test "should return key as to_s" do
		address_type = Factory(:address_type)
		assert_equal address_type.key, "#{address_type}"
	end

end
