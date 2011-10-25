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
		phone_type = create_phone_type
		assert_equal phone_type.code, "#{phone_type}"
	end

	test "should find by code with ['string']" do
		phone_type = PhoneType['home']
		assert phone_type.is_a?(PhoneType)
	end

	test "should find by code with [:symbol]" do
		phone_type = PhoneType[:home]
		assert phone_type.is_a?(PhoneType)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(PhoneType::NotFound) {
#			phone_type = PhoneType['idonotexist']
#		}
#	end


protected

	def create_phone_type(options={})
		phone_type = Factory.build(:phone_type,options)
		phone_type.save
		phone_type
	end

end
