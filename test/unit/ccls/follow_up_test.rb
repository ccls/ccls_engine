require 'test_helper'

class Ccls::FollowUpTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(
		:section,
		:enrollment,
		:follow_up_type)

	test "explicit Factory follow_up test" do
		assert_difference('FollowUpType.count',1) {
		assert_difference('Enrollment.count',2) {	#	again, creates subject, which creates ccls enrollment
		assert_difference('Section.count',1) {
		assert_difference('FollowUp.count',1) {
			follow_up = Factory(:follow_up)
			assert_not_nil follow_up.section
			assert_not_nil follow_up.enrollment
			assert_not_nil follow_up.follow_up_type
		} } } }
	end

end
