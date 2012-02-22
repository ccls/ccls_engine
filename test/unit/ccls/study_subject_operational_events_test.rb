require 'test_helper'

#	This is just a collection of race related tests 
#	for StudySubject separated only for clarity due
#	to the size of the StudySubjectTest class.
class Ccls::StudySubjectOperationalEventsTest < ActiveSupport::TestCase

	test "should create newSubject operational event on creation" do
		study_subject = nil
		assert_difference('OperationalEventType.count',0) {	#	make sure it didn't create it
		assert_difference('OperationalEvent.count',1) {
		assert_difference('StudySubject.count',1) {
			study_subject = Factory(:study_subject)
		} } }
		ccls_enrollment = study_subject.enrollments.find_by_project_id(Project['ccls'].id)
		assert_not_nil ccls_enrollment
		assert_not_nil ccls_enrollment.operational_events.find_by_operational_event_type_id(
			OperationalEventType['newSubject'].id )
	end

	test "should create subjectDied operational event when vital status changed to deceased" do
		study_subject = Factory(:study_subject).reload
		assert_not_nil study_subject.vital_status
		assert_difference('OperationalEventType.count',0) {	#	make sure it didn't create it
		assert_difference('OperationalEvent.count',1) {
			study_subject.update_attributes(:vital_status_id => VitalStatus['deceased'].id)
		} }
		assert_equal study_subject.reload.vital_status, VitalStatus['deceased']
		ccls_enrollment = study_subject.enrollments.find_by_project_id(Project['ccls'].id)
		assert_not_nil ccls_enrollment
		assert_not_nil ccls_enrollment.operational_events.find_by_operational_event_type_id(
			OperationalEventType['subjectDied'].id )
	end

	test "should return nil for subject's screener_complete_date_for_open_project" <<
			" when subject has no associated operational event type" do
		study_subject = Factory(:study_subject)
		assert_nil study_subject.screener_complete_date_for_open_project
	end

	test "should return date for subject's screener_complete_date_for_open_project" <<
			" when subject has associated operational event type" do
		study_subject = Factory(:study_subject)
		assert_nil study_subject.screener_complete_date_for_open_project
		ccls_enrollment = study_subject.enrollments.find_by_project_id(Project['ccls'].id)
		ccls_enrollment.operational_events.create(
			:operational_event_type_id => OperationalEventType['screener_complete'].id,
			:occurred_on => Date.today)
		date = study_subject.screener_complete_date_for_open_project
		assert_equal date, Date.today
	end

end
