require File.dirname(__FILE__) + '/../test_helper'

class InterviewOutcomeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:homex_outcomes)
	assert_should_require_attributes(:code)
	assert_should_require_unique_attributes(:code)
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :description )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :code )
		o.assert_should_require_attribute_length( :description )
	end

	test "should return description as to_s" do
		object = create_object(:description => "Description")
		assert_equal object.description,
			"#{object}"
	end

	test "should find by code with ['string']" do
		object = InterviewOutcome['complete']
		assert object.is_a?(InterviewOutcome)
	end

	test "should find by code with [:symbol]" do
		object = InterviewOutcome[:complete]
		assert object.is_a?(InterviewOutcome)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(InterviewOutcome::NotFound) {
#			object = InterviewOutcome['idonotexist']
#		}
#	end

end
