require 'test_helper'

class Ccls::IneligibleReasonTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list

#	only if study_subject is ineligible
#	assert_should_have_many(:enrollments)

	assert_should_not_require_attributes( :position, :ineligible_context )

	test "explicit Factory ineligible_reason test" do
		assert_difference('IneligibleReason.count',1) {
			ineligible_reason = Factory(:ineligible_reason)
			assert_match /Key\d*/, ineligible_reason.key
			assert_match /Desc\d*/, ineligible_reason.description
		}
	end

	test "should return description as to_s" do
		ineligible_reason = create_ineligible_reason
		assert_equal ineligible_reason.description, "#{ineligible_reason}"
	end

	test "should find random" do
		ineligible_reason = IneligibleReason.random()
		assert ineligible_reason.is_a?(IneligibleReason)
	end

	test "should return nil on random when no records" do
#		IneligibleReason.destroy_all
		IneligibleReason.stubs(:count).returns(0)
		ineligible_reason = IneligibleReason.random()
		assert_nil ineligible_reason
	end

#protected
#
#	def create_ineligible_reason(options={})
#		ineligible_reason = Factory.build(:ineligible_reason,options)
#		ineligible_reason.save
#		ineligible_reason
#	end

end
