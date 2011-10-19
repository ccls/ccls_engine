require 'test_helper'

class Ccls::SampleOutcomeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :homex_outcomes )
	assert_should_require_attributes( :code )
	assert_should_require_unique_attributes( :code )
	assert_should_not_require_attributes( :position, :description )
	assert_should_require_attribute_length( :code, :description, :maximum => 250 )

	test "should return description as to_s" do
		sample_outcome = create_sample_outcome(:description => "Description")
		assert_equal sample_outcome.description,
			"#{sample_outcome}"
	end

	test "should find by code with ['string']" do
		sample_outcome = SampleOutcome['complete']
		assert sample_outcome.is_a?(SampleOutcome)
	end

	test "should find by code with [:symbol]" do
		sample_outcome = SampleOutcome[:complete]
		assert sample_outcome.is_a?(SampleOutcome)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(SampleOutcome::NotFound) {
#			sample_outcome = SampleOutcome['idonotexist']
#		}
#	end

protected

	def create_sample_outcome(options={})
		sample_outcome = Factory.build(:sample_outcome,options)
		sample_outcome.save
		sample_outcome
	end

end
