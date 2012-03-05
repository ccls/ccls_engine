require 'test_helper'

class Ccls::InstrumentTypeTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:instrument_versions)
	assert_should_initially_belong_to(:project)
	assert_should_not_require_attributes( :position )

	test "explicit Factory instrument_type test" do
		assert_difference('Project.count',1) {
		assert_difference('InstrumentType.count',1) {
			instrument_type = Factory(:instrument_type)
			assert_not_nil instrument_type.project
			assert_match /Key\d*/, instrument_type.key
			assert_match /Desc\d*/, instrument_type.description
		} }
	end

	test "should require project" do
		assert_difference( "InstrumentType.count", 0 ) do
			instrument_type = create_instrument_type( :project => nil)
			assert !instrument_type.errors.on(:project)
			assert  instrument_type.errors.on_attr_and_type?(:project_id,:blank)
		end
	end

	test "should require valid project" do
		assert_difference( "InstrumentType.count", 0 ) do
			instrument_type = create_instrument_type( :project_id => 0)
			assert !instrument_type.errors.on(:project_id)
			assert  instrument_type.errors.on_attr_and_type?(:project,:blank)
		end
	end

end
