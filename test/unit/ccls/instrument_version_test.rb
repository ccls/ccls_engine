require 'test_helper'

class Ccls::InstrumentVersionTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :interviews )
	assert_should_belong_to( :language, :instrument )
	assert_should_initially_belong_to( :instrument_type )
	assert_should_not_require_attributes( 
		:position,
		:language_id,
		:began_use_on,
		:ended_use_on,
		:instrument_id )

	assert_requires_complete_date( :began_use_on, :ended_use_on )

	test "explicit Factory instrument_version test" do
		assert_difference('InstrumentType.count',1) {
		assert_difference('InstrumentVersion.count',1) {
			instrument_version = Factory(:instrument_version)
			assert_not_nil instrument_version.instrument_type
			assert_match /Key\d*/, instrument_version.key
			assert_match /Desc\d*/, instrument_version.description
		} }
	end

	test "should require instrument_type" do
		assert_difference( "InstrumentVersion.count", 0 ) do
			instrument_version = create_instrument_version( :instrument_type => nil)
			assert !instrument_version.errors.on(:instrument_type)
			assert  instrument_version.errors.on_attr_and_type?(:instrument_type_id,:blank)
		end
	end

	test "should require valid instrument_type" do
		assert_difference( "InstrumentVersion.count", 0 ) do
			instrument_version = create_instrument_version( :instrument_type_id => 0)
			assert !instrument_version.errors.on(:instrument_type_id)
			assert  instrument_version.errors.on_attr_and_type?(:instrument_type,:blank)
		end
	end

	test "should return description as to_s" do
		instrument_version = create_instrument_version
		assert_equal instrument_version.description, "#{instrument_version}"
	end

	test "should find random" do
		instrument_version = InstrumentVersion.random()
		assert instrument_version.is_a?(InstrumentVersion)
	end

	test "should return nil on random when no records" do
		InstrumentVersion.stubs(:count).returns(0)
		instrument_version = InstrumentVersion.random()
		assert_nil instrument_version
	end

#protected
#
#	def create_instrument_version(options={})
#		instrument_version = Factory.build(:instrument_version,options)
#		instrument_version.save
#		instrument_version
#	end

end
