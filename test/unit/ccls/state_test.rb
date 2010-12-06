require File.dirname(__FILE__) + '/../test_helper'

class StateTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_require_attributes( :code )
	assert_should_require_attributes( :name )
	assert_should_require_attributes( :fips_state_code )
	assert_should_require_attributes( :fips_country_code )
	assert_should_require_unique_attributes( :code )
	assert_should_require_unique_attributes( :name )
	assert_should_require_unique_attributes( :fips_state_code )
	assert_should_not_require_attributes( :position )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :code )
		o.assert_should_require_attribute_length( :name )
		o.assert_should_require_attribute_length( :fips_state_code )
		o.assert_should_require_attribute_length( :fips_country_code )
	end

end
