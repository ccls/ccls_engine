require 'test_helper'

class Ccls::SubjectTypeTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:study_subjects)
	assert_should_not_require_attributes( :position, :related_case_control_type )

	test "explicit Factory subject_type test" do
		assert_difference('SubjectType.count',1) {
			subject_type = Factory(:subject_type)
			assert_match /Key\d*/, subject_type.key
			assert_match /Desc\d*/, subject_type.description
		}
	end

	test "should return description as name" do
		subject_type = create_subject_type
		assert_equal subject_type.description,
			subject_type.name
	end

	test "should return description as to_s" do
		subject_type = create_subject_type
		assert_equal subject_type.description,
			"#{subject_type}"
	end

#protected
#
#	def create_subject_type(options={})
#		subject_type = Factory.build(:subject_type,options)
#		subject_type.save
#		subject_type
#	end

end
