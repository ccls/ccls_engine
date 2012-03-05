require 'test_helper'

class Ccls::InterviewOutcomeTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:homex_outcomes)
	assert_should_not_require_attributes( :position )

	test "explicit Factory interview_outcome test" do
		assert_difference('InterviewOutcome.count',1) {
			interview_outcome = Factory(:interview_outcome)
			assert_match /Key\d*/,  interview_outcome.key
			assert_match /Desc\d*/, interview_outcome.description
		}
	end

	test "should return description as to_s" do
		interview_outcome = create_interview_outcome(:description => "Description")
		assert_equal interview_outcome.description,
			"#{interview_outcome}"
	end

#protected
#
#	def create_interview_outcome(options={})
#		interview_outcome = Factory.build(:interview_outcome,options)
#		interview_outcome.save
#		interview_outcome
#	end

end
