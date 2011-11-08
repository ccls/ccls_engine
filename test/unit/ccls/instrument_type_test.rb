require 'test_helper'

class Ccls::InstrumentTypeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:instrument_versions)
	assert_should_initially_belong_to(:project)
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position )
	assert_should_require_attribute_length( :code, :maximum => 250 )
	assert_should_require_attribute_length( :description, :in => 4..250 )

	test "should require project" do
		assert_difference( "InstrumentType.count", 0 ) do
			instrument_type = create_instrument_type( :project => nil)
			assert instrument_type.errors.on(:project)
		end
	end

	test "should require valid project" do
		assert_difference( "InstrumentType.count", 0 ) do
			instrument_type = create_instrument_type( :project_id => 0)
			assert instrument_type.errors.on(:project)
		end
	end

end
