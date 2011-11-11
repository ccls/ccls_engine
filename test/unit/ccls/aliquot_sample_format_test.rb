require 'test_helper'

class Ccls::AliquotSampleFormatTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_require_attribute_length(:description, :in => 4..250 )
	assert_should_require_attribute_length( :code, :maximum => 250 )
	assert_should_not_require_attributes(:position)
	assert_should_act_as_list
	assert_should_have_many( :aliquots, :samples )

	test "explicit Factory aliquot_sample_format test" do
		assert_difference('AliquotSampleFormat.count',1) {
			aliquot_sample_format = Factory(:aliquot_sample_format)
			assert_match /Code\d*/, aliquot_sample_format.code
			assert_match /Desc\d*/, aliquot_sample_format.description
		}
	end

end
