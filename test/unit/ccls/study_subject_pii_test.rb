require 'test_helper'

#	TODO these tests will need implemented somehow

#	This is just a collection of pii related tests 
#	for StudySubject separated only for clarity due
#	to the size of the StudySubjectTest class.
class Ccls::StudySubjectPiiTest < ActiveSupport::TestCase

	test "should be ineligible for invitation without email" do
		study_subject = create_study_subject(:email => nil)
		assert_nil study_subject.email
		assert !study_subject.is_eligible_for_invitation?
	end

	test "should be eligible for invitation with email" do
		study_subject = create_study_subject
		assert_not_nil study_subject.email
		assert study_subject.is_eligible_for_invitation?
	end

	test "should return 'name not available' for study_subject without names" do
		study_subject = create_study_subject
		assert_nil study_subject.first_name
		assert_nil study_subject.middle_name
		assert_nil study_subject.last_name
		assert_equal '[name not available]', study_subject.full_name
	end

	test "should not require dob on creation for mother without flag" do
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(
				:subject_type => SubjectType['Mother'],
				:dob => nil )
		}
		assert_nil @study_subject.reload.dob
	end

	test "should not require dob on update for mother" do
		#	flag not necessary as study_subject.subject_type exists
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_type => SubjectType['Mother'] )
		}
		assert_not_nil @study_subject.reload.dob
		@study_subject.update_attributes(:dob => nil)
		assert_nil @study_subject.reload.dob
	end

end
