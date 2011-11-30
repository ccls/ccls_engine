require 'test_helper'

class Ccls::InstrumentTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:instrument_versions)
	assert_should_belong_to(:interview_method)
	assert_should_initially_belong_to(:project)
	assert_should_require_attributes( :code, :name, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position,
		:results_table_id,
		:interview_method_id,
		:began_use_on,
		:ended_use_on )
	assert_should_require_attribute_length( :code, :name, 
		:maximum => 250 )
	assert_should_require_attribute_length( :description, :in => 4..250 )
	assert_requires_complete_date( :began_use_on, :ended_use_on )

	test "explicit Factory instrument test" do
		assert_difference('Project.count',1) {
		assert_difference('Instrument.count',1) {
			instrument = Factory(:instrument)
			assert_not_nil instrument.project
			assert_equal 'Instrument Name', instrument.name
			assert_match /Code\d*/, instrument.code
			assert_match /Desc\d*/, instrument.description
		} }
	end

	#	unfortunately name is NOT unique so should change this
	test "should return name as to_s" do
		instrument = create_instrument
		assert_equal instrument.name, "#{instrument}"
	end

	test "should require project" do
		assert_difference( "Instrument.count", 0 ) do
			instrument = create_instrument( :project => nil)
# validate on foreign key rather than association so error shows up correctly in view.
#			assert instrument.errors.on(:project)
			assert instrument.errors.on_attr_and_type(:project_id,:blank)
		end
	end

# validate on foreign key rather than association so error shows up correctly in view.
#	test "should require valid project" do
#		assert_difference( "Instrument.count", 0 ) do
#			instrument = create_instrument( :project_id => 0)
#			assert instrument.errors.on(:project)
#		end
#	end

#protected
#
#	def create_instrument(options={})
#		instrument = Factory.build(:instrument,options)
#		instrument.save
#		instrument
#	end

end
