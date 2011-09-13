require 'test_helper'

class Ccls::SubjectTypeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:study_subjects)
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position, :related_case_control_type )
	assert_should_require_attribute_length( :code, :description, :maximum => 250 )

	test "should return description as name" do
		object = create_object
		assert_equal object.description,
			object.name
	end

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description,
			"#{object}"
	end

	test "should find by code with ['string']" do
		object = SubjectType['Case']
		assert object.is_a?(SubjectType)
	end

	test "should find by code with [:symbol]" do
		object = SubjectType[:Case]
		assert object.is_a?(SubjectType)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(SubjectType::NotFound) {
#			object = SubjectType['idonotexist']
#		}
#	end

end
