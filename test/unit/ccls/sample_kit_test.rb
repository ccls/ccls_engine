require 'test_helper'

class Ccls::SampleKitTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to( :sample )
	assert_should_require_unique_attribute( :sample_id )

	test "explicit Factory sample_kit test" do
		assert_difference('Sample.count',1) {
		assert_difference('SampleKit.count',1) {
			sample_kit = Factory(:sample_kit)
			assert_not_nil sample_kit.sample
		} }
	end

	test "should require a unique sample" do
		assert_difference( "SampleKit.count", 1 ) {
		assert_difference('Sample.count', 1) {
			sample_kit = create_sample_kit
			assert_not_nil sample_kit.sample
			sample_kit = create_sample_kit(:sample_id => sample_kit.sample_id)
			assert sample_kit.errors.on(:sample_id)
		} }
	end

#protected
#
#	def create_sample_kit(options={})
#		sample_kit = Factory.build(:sample_kit,options)
#		sample_kit.save
#		sample_kit
#	end

end
