require 'test_helper'

class Ccls::StateTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_require_attributes( :code, :name, :fips_state_code, :fips_country_code )
	assert_should_require_unique_attributes( :code, :name, :fips_state_code )
	assert_should_not_require_attributes( :position )
	assert_should_require_attribute_length( :code, :name, 
		:fips_state_code, :fips_country_code, 
			:maximum => 250 )

	test "explicit Factory state test" do
		assert_difference('State.count',1) {
			state = Factory(:state)
			assert_match /Code\d*/, state.code
			assert_match /Name\d*/, state.name
			assert_not_nil state.fips_state_code
			assert_equal 'US', state.fips_country_code
		}
	end

	test "should return an array of state abbreviations" do
		abbreviations = State.abbreviations
		assert_not_nil abbreviations
		assert abbreviations.is_a?(Array)
		assert abbreviations.length > 50
	end

end
