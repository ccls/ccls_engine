require 'test_helper'

class Ccls::ProjectOutcomeTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_not_require_attributes( :position, :project_id )
	assert_should_have_many( :enrollments )

	test "explicit Factory project_outcome test" do
		assert_difference('ProjectOutcome.count',1) {
			project_outcome = Factory(:project_outcome)
			assert_match /Key\d*/, project_outcome.key
			assert_match /Desc\d*/, project_outcome.description
		}
	end

	test "should return description as to_s" do
		project_outcome = create_project_outcome
		assert_equal project_outcome.description,
			"#{project_outcome}"
	end

#protected
#
#	def create_project_outcome(options={})
#		project_outcome = Factory.build(:project_outcome,options)
#		project_outcome.save
#		project_outcome
#	end

end
