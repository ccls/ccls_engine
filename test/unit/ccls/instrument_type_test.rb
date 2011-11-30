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

	test "explicit Factory instrument_type test" do
		assert_difference('Project.count',1) {
		assert_difference('InstrumentType.count',1) {
			instrument_type = Factory(:instrument_type)
			assert_not_nil instrument_type.project
			assert_match /Code\d*/, instrument_type.code
			assert_match /Desc\d*/, instrument_type.description
		} }
	end

	test "should require project" do
		assert_difference( "InstrumentType.count", 0 ) do
			instrument_type = create_instrument_type( :project => nil)
# validate on foreign key rather than association so error shows up correctly in view.
#			assert instrument_type.errors.on(:project)
			assert instrument_type.errors.on_attr_and_type(:project_id,:blank)
		end
	end

# validate on foreign key rather than association so error shows up correctly in view.
#	test "should require valid project" do
#		assert_difference( "InstrumentType.count", 0 ) do
#			instrument_type = create_instrument_type( :project_id => 0)
#			assert instrument_type.errors.on(:project)
#		end
#	end

end
