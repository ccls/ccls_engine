require 'test_helper'

class Ccls::AliquotSampleFormatTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_not_require_attributes(:position)
	assert_should_act_as_list
	assert_should_have_many( :aliquots, :samples )

	test "explicit Factory aliquot_sample_format test" do
		assert_difference('AliquotSampleFormat.count',1) {
			aliquot_sample_format = Factory(:aliquot_sample_format)
			assert_match /Key\d*/,  aliquot_sample_format.key
			assert_match /Desc\d*/, aliquot_sample_format.description
		}
	end

end
