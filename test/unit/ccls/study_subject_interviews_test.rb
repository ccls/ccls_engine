require 'test_helper'

class Ccls::StudySubjectInterviewsTest < ActiveSupport::TestCase

	test "should NOT destroy interviews with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Interview.count',1) {
			@study_subject = Factory(:interview).study_subject
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('Interview.count',0) {
			@study_subject.destroy
		} }
	end

	test "should not have hx_interview" do
		study_subject = create_study_subject
		assert_nil study_subject.hx_interview
	end

	test "should have hx_interview" do
		study_subject = create_hx_interview_study_subject
		assert_not_nil study_subject.hx_interview
	end

end
