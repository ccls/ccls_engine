require 'test_helper'

class Ccls::UnitTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :aliquots, :samples )
	assert_should_belong_to( :context )
	assert_should_not_require_attributes( :position, :context_id )

	test "explicit Factory unit test" do
		assert_difference('Unit.count',1) {
			unit = Factory(:unit)
			assert_match /Key\d*/, unit.key
			assert_match /Desc\d*/, unit.description
		}
	end

end
