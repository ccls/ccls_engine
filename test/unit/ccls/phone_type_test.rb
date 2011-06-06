require 'test_helper'

class Ccls::PhoneTypeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:phone_numbers)
	assert_should_require_attributes(:code)
	assert_should_require_unique_attributes(:code)
	assert_should_not_require_attributes( :position, :description )
	assert_should_require_attribute_length( :code, :in => 4..250 )
	assert_should_require_attribute_length( :description, :maximum => 250 )

	test "should return code as to_s" do
		object = create_object
		assert_equal object.code, "#{object}"
	end

end
