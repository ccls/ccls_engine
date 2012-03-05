require 'test_helper'

class Ccls::SampleOutcomeTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :homex_outcomes )
	assert_should_not_require_attributes( :position )

	test "explicit Factory sample_outcome test" do
		assert_difference('SampleOutcome.count',1) {
			sample_outcome = Factory(:sample_outcome)
			assert_match /Key\d*/,  sample_outcome.key
			assert_match /Desc\d*/, sample_outcome.description
		}
	end

	test "should return description as to_s" do
		sample_outcome = create_sample_outcome(:description => "Description")
		assert_equal sample_outcome.description,
			"#{sample_outcome}"
	end

#protected
#
#	def create_sample_outcome(options={})
#		sample_outcome = Factory.build(:sample_outcome,options)
#		sample_outcome.save
#		sample_outcome
#	end

end
