require 'test_helper'

class Ccls::UnitTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :aliquots, :samples )
	assert_should_belong_to( :context )
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position, :context_id )
	assert_should_require_attribute_length( :description, :in => 4..250 )
	assert_should_require_attribute_length( :code, :maximum => 250 )

	test "explicit Factory unit test" do
		assert_difference('Unit.count',1) {
			unit = Factory(:unit)
			assert_match /Code\d*/, unit.code
			assert_match /Desc\d*/, unit.description
		}
	end

end
