require 'test_helper'

class Ccls::InterviewOutcomeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:homex_outcomes)
	assert_should_require_attributes(:code)
	assert_should_require_unique_attributes(:code)
	assert_should_not_require_attributes( :position, :description )
	assert_should_require_attribute_length( :code, :description, 
		:maximum => 250 )

	test "should return description as to_s" do
		interview_outcome = create_interview_outcome(:description => "Description")
		assert_equal interview_outcome.description,
			"#{interview_outcome}"
	end

	test "should find by code with ['string']" do
		interview_outcome = InterviewOutcome['complete']
		assert interview_outcome.is_a?(InterviewOutcome)
	end

	test "should find by code with [:symbol]" do
		interview_outcome = InterviewOutcome[:complete]
		assert interview_outcome.is_a?(InterviewOutcome)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(InterviewOutcome::NotFound) {
#			interview_outcome = InterviewOutcome['idonotexist']
#		}
#	end

protected

	def create_interview_outcome(options={})
		interview_outcome = Factory.build(:interview_outcome,options)
		interview_outcome.save
		interview_outcome
	end

end
