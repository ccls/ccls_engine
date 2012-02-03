require 'test_helper'

class Ccls::IcfMasterTrackerTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require(:Masterid)
	assert_should_require_unique(:Masterid)

	test "should not attach to study subject on create if none exists" do
		icf_master_tracker = Factory(:icf_master_tracker,
			:Masterid => '1234')
		assert_nil icf_master_tracker.study_subject
	end

	test "should attach to study subject on create if exists" do
		icf_master_id = Factory(:icf_master_id, :icf_master_id => '1234')
		study_subject = Factory(:complete_case_study_subject)
		study_subject.assign_icf_master_id
		icf_master_tracker = Factory(:icf_master_tracker,
			:Masterid => '1234')
		assert_not_nil icf_master_tracker.study_subject
		assert_equal   icf_master_tracker.study_subject, study_subject
	end

	test "should attach to study subject on update if exists" do
		icf_master_tracker = Factory(:icf_master_tracker,
			:Masterid => '1234')
		assert_nil icf_master_tracker.study_subject
		icf_master_id = Factory(:icf_master_id, :icf_master_id => '1234')
		study_subject = Factory(:complete_case_study_subject)
		study_subject.assign_icf_master_id
		icf_master_tracker.save
		assert_not_nil icf_master_tracker.study_subject
		assert_equal   icf_master_tracker.study_subject, study_subject
	end

	test "should create operational event for study subject if change" do
		icf_master_id = Factory(:icf_master_id, :icf_master_id => '1234')
		study_subject = Factory(:complete_case_study_subject)
		study_subject.assign_icf_master_id
		assert_difference('OperationalEvent.count',1) {
			icf_master_tracker = Factory(:icf_master_tracker,
				:Masterid => '1234', :Eligible => 'trigger change')
			assert_not_nil icf_master_tracker.study_subject
			assert_equal   icf_master_tracker.study_subject, study_subject
			assert icf_master_tracker.study_subject.enrollments.find_by_project_id(
				Project['ccls'].id).operational_events.collect(&:operational_event_type_id
				).include?(OperationalEventType[:other].id)
		}
	end

	test "should not create operational event for study subject if no change" do
		icf_master_id = Factory(:icf_master_id, :icf_master_id => '1234')
		study_subject = Factory(:complete_case_study_subject)
		study_subject.assign_icf_master_id
		assert_difference('OperationalEvent.count',0) {
			icf_master_tracker = Factory(:icf_master_tracker,
				:Masterid => '1234')	#, :Eligible => 'trigger change')
			assert_not_nil icf_master_tracker.study_subject
			assert_equal   icf_master_tracker.study_subject, study_subject
			assert !icf_master_tracker.study_subject.enrollments.find_by_project_id(
				Project['ccls'].id).operational_events.collect(&:operational_event_type_id
				).include?(OperationalEventType[:other].id)
		}
	end

end
