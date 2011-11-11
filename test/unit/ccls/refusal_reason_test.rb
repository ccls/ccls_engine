require 'test_helper'

class Ccls::RefusalReasonTest < ActiveSupport::TestCase

#	Only IF study_subject not consented
#	assert_should_have_many(:enrollments)

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position )
	assert_should_require_attribute_length( :description, :in => 4..250 )
	assert_should_require_attribute_length( :code, :maximum => 250 )

	test "explicit Factory refusal_reason test" do
		assert_difference('RefusalReason.count',1) {
			refusal_reason = Factory(:refusal_reason)
			assert_match /Code\d*/, refusal_reason.code
			assert_match /Desc\d*/, refusal_reason.description
		}
	end

	test "should return description as to_s" do
		refusal_reason = create_refusal_reason
		assert_equal refusal_reason.description, "#{refusal_reason}"
	end

	test "should find by code with ['string']" do
		refusal_reason = RefusalReason['busy']
		assert refusal_reason.is_a?(RefusalReason)
	end

	test "should find by code with [:symbol]" do
		refusal_reason = RefusalReason[:busy]
		assert refusal_reason.is_a?(RefusalReason)
	end

	test "should find random" do
		refusal_reason = RefusalReason.random()
		assert refusal_reason.is_a?(RefusalReason)
	end

	test "should return nil on random when no records" do
#		RefusalReason.destroy_all
		RefusalReason.stubs(:count).returns(0)
		refusal_reason = RefusalReason.random()
		assert_nil refusal_reason
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(RefusalReason::NotFound) {
#			refusal_reason = RefusalReason['idonotexist']
#		}
#	end

#protected
#
#	def create_refusal_reason(options={})
#		refusal_reason = Factory.build(:refusal_reason,options)
#		refusal_reason.save
#		refusal_reason
#	end

end
