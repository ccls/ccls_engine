require 'test_helper'

class Ccls::CountyTest < ActiveSupport::TestCase
	assert_should_create_default_object
	assert_should_have_many(:zip_codes)
	assert_should_require( :name, :state_abbrev )
	assert_should_not_require( :fips_code )
	assert_should_require_length( :name, :maximum => 250 )
	assert_should_require_length( :state_abbrev, :maximum => 2 )
	assert_should_require_length( :fips_code, :maximum => 5 )
end
