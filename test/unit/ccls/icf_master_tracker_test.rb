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

end
