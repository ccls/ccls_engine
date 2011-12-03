require 'test_helper'

class Ccls::CandidateControlTest < ActiveSupport::TestCase
	
	assert_should_create_default_object
	assert_should_belong_to( :study_subject )
	assert_should_require_attributes( 
		:first_name,
		:last_name,
		:dob )
	assert_should_not_require_attributes( 
		:mother_first_name,
		:mother_middle_name,
		:mother_last_name,
		:mother_dob,
		:icf_master_id,
		:related_patid,
		:middle_name,
		:state_registrar_no,
		:local_registrar_no,
		:birth_county,
		:assigned_on,
		:mother_race_id,
		:mother_hispanicity_id,
		:father_race_id,
		:father_hispanicity_id,
		:birth_type,
		:mother_maiden_name,
		:mother_yrs_educ,
		:father_yrs_educ,
		:rejection_reason )
	assert_should_require_attribute_length( :related_patid, :is => 4 )
	assert_should_require_attribute_length( :state_registrar_no, :maximum => 25 )
	assert_should_require_attribute_length( :local_registrar_no, :maximum => 25 )
	assert_should_require_attribute_length( 
		:first_name,
		:middle_name,
		:last_name,
		:birth_county,
		:birth_type,
		:mother_maiden_name,
		:rejection_reason,
			:maximum => 250 )
	assert_should_require_attributes_not_nil( :sex )

	test "explicit Factory candidate_control test" do
		assert_difference('CandidateControl.count',1) {
			candidate_control = Factory(:candidate_control)
			assert_equal 'First', candidate_control.first_name
			assert_equal 'Last',  candidate_control.last_name
			assert_not_nil candidate_control.dob
			assert_not_nil candidate_control.reject_candidate
			assert !candidate_control.reject_candidate
			assert_not_nil candidate_control.sex
		}
	end

	test "should require sex be either M, F or DK" do
		assert_difference("CandidateControl.count",0) {
			candidate_control = create_candidate_control(:sex => 'X')
			assert candidate_control.errors.on_attr_and_type?(:sex,:inclusion)
		} 
	end

	test "should require rejection_reason if reject_candidate is true" do
		assert_difference("CandidateControl.count",0) {
			candidate_control = create_candidate_control(
				:reject_candidate => true,
				:rejection_reason => nil)
			assert candidate_control.errors.on_attr_and_type?(:rejection_reason,:blank)
		}
	end

	test "should not require rejection_reason if reject_candidate is false" do
		assert_difference("CandidateControl.count",1) {
			candidate_control = create_candidate_control(
				:reject_candidate => false,
				:rejection_reason => nil)
		}
	end

	test "should require reject_candidate is not nil" do
		assert_difference("CandidateControl.count",0) {
			candidate_control = create_candidate_control(:reject_candidate => nil)
			assert candidate_control.errors.on_attr_and_type?(:reject_candidate,:inclusion)
		}
	end

	test "should return join of candidate's name" do
		candidate_control = create_candidate_control(
			:first_name => "John",
			:last_name  => "Smith" )
		assert_equal 'John Smith', candidate_control.full_name 
	end

	################################################################################
	#
	#	BEGIN: MANY subject creation tests
	#

	test "should create study_subjects from attributes" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		candidate_control.reload	# ensure that it is saved in the db!
		assert_not_nil candidate_control.assigned_on
		assert_not_nil candidate_control.study_subject_id
	end

	test "should create control with enrollment in ccls" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		assert !candidate_control.study_subject.enrollments.empty?
		assert_equal [Project['ccls']],
			candidate_control.study_subject.enrollments.collect(&:project)
	end

	test "should create control from attributes" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		assert_nil     candidate_control.study_subject.reference_date
	end

	test "should create control from attributes and copy case patid" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		control_subject = candidate_control.study_subject
		assert_not_nil control_subject.patid
		assert_equal   control_subject.patid, case_study_subject.patid
	end

	test "should create control from attributes and set hispanicity_id nil" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		control_subject = candidate_control.study_subject
		assert_nil control_subject.hispanicity_id
	end

	test "should create control from attributes and set hispanicity_id if father_hispanicity" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control( :father_hispanicity_id => 1 )
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		control_subject = candidate_control.study_subject
		assert_not_nil control_subject.hispanicity_id
		assert_equal   control_subject.hispanicity_id, 1
	end

	test "should create control from attributes and set hispanicity_id if mother_hispanicity" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control( :mother_hispanicity_id => 1 )
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		control_subject = candidate_control.study_subject
		assert_not_nil control_subject.hispanicity_id
		assert_equal   control_subject.hispanicity_id, 1
	end

	test "should create control from attributes with patient" do
		case_study_subject = create_case_identifier.study_subject
		create_patient_for_subject(case_study_subject)
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
	end

	test "should create control from attributes with patient and copy case admit_date" do
		case_study_subject = create_case_identifier.study_subject
		create_patient_for_subject(case_study_subject)
		case_study_subject.reload
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		control_subject = candidate_control.study_subject
		assert_not_nil control_subject.reference_date
		assert_equal   control_subject.reference_date, case_study_subject.patient.admit_date
	end

	test "should create control from attributes and add subjectid" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		assert_not_nil candidate_control.study_subject.identifier.subjectid
		assert_equal   candidate_control.study_subject.identifier.subjectid.length, 6
	end

	test "should create control from attributes and add familyid" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		assert_not_nil candidate_control.study_subject.identifier.familyid
		assert_equal   candidate_control.study_subject.identifier.familyid.length, 6
	end

	test "should create control from attributes and subjectid should equal familyid" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		assert_equal   candidate_control.study_subject.identifier.familyid, 
										candidate_control.study_subject.identifier.subjectid
	end

	test "should create control from attributes and copy case matchingid" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		assert_not_nil candidate_control.study_subject.identifier.matchingid
		assert_equal   candidate_control.study_subject.identifier.matchingid, 
									case_study_subject.identifier.matchingid
	end

	test "should create control from attributes and add orderno = 1" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		assert_not_nil candidate_control.study_subject.identifier.orderno
		#	As this will be the first control here ...
		assert_equal   candidate_control.study_subject.identifier.orderno, 1		
	end

	test "should create second control from attributes and add orderno = 2" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control_1 = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control_1,case_study_subject)
		candidate_control_2 = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control_2,case_study_subject)
		assert_not_nil candidate_control_2.study_subject.identifier.orderno
		#	As this will be the second control here ...
		assert_equal   candidate_control_2.study_subject.identifier.orderno, 2		
	end

	test "should create control from attributes and add studyid" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		assert_not_nil candidate_control.study_subject.identifier.studyid		
		assert_match /\d{4}-\d-\d/, candidate_control.study_subject.identifier.studyid
	end

	#	icf_master_id isn't required as may not have any
	test "should create control from attributes and add icf_master_id if any" do
		imi = Factory(:icf_master_id,:icf_master_id => '123456789')
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		assert_not_nil candidate_control.study_subject.identifier.icf_master_id
		assert_equal   candidate_control.study_subject.identifier.icf_master_id, '123456789'
		assert_not_nil imi.reload.study_subject
		assert_equal   imi.study_subject, candidate_control.study_subject
		assert_not_nil imi.assigned_on
		assert_equal   imi.assigned_on, Date.today
	end

	test "should create mother from attributes" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		assert_not_nil candidate_control.study_subject.mother
		mother = candidate_control.study_subject.mother
		assert_nil mother.identifier.case_control_type
		assert_nil mother.identifier.orderno
	end

	test "should create mother from attributes and NOT copy case patid" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		mother = candidate_control.study_subject.mother
		assert_nil mother.patid
	end

	test "should create mother from attributes with patient and copy case admit_date" do
		case_study_subject = create_case_identifier.study_subject
		create_patient_for_subject(case_study_subject)
		case_study_subject.reload
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		mother = candidate_control.study_subject.reload.mother
		assert_not_nil mother.reference_date
		assert_equal   mother.reference_date, case_study_subject.patient.admit_date
	end

	test "should create mother from attributes and copy case matchingid" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		mother = candidate_control.study_subject.mother
		assert_not_nil mother.identifier.matchingid
		assert_equal   mother.identifier.matchingid, 
									case_study_subject.identifier.matchingid
	end

	test "should create mother from attributes and copy child familyid" do
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		mother = candidate_control.study_subject.mother
		assert_not_nil mother.identifier.familyid
		assert_equal   candidate_control.study_subject.identifier.familyid, 
										mother.identifier.familyid
	end

	#	icf_master_id isn't required as may not have any
	test "should create mother from attributes and add icf_master_id if any" do
		Factory(:icf_master_id,:icf_master_id => 'child')
		imi = Factory(:icf_master_id,:icf_master_id => '123456789')
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
		assert_not_nil candidate_control.study_subject.mother.identifier.icf_master_id
		assert_equal   candidate_control.study_subject.mother.identifier.icf_master_id, '123456789'
		assert_not_nil imi.reload.study_subject
		assert_equal   imi.study_subject, candidate_control.study_subject.mother
		assert_not_nil imi.assigned_on
		assert_equal   imi.assigned_on, Date.today
	end

	test "should rollback study subject creation of icf_master_id save fails" do
pending #	TODO wrap in transaction.  Don't want this partially done.
		Factory(:icf_master_id,:icf_master_id => 'child')
		imi = Factory(:icf_master_id,:icf_master_id => '123456789')
		case_study_subject = create_case_identifier.study_subject
		candidate_control = create_candidate_control
		create_study_subjects_for_candidate_control(candidate_control,case_study_subject)
#	none of these are actually stopping this!
#		IcfMasterId.any_instance.stubs(:create_or_update).returns(false)
#		IcfMasterId.any_instance.stubs(:valid?).returns(false)
#		IcfMasterId.any_instance.stubs(:save!).raises(ActiveRecord::RecordNotSaved)
		assert_difference('Enrollment.count',0) {
		assert_difference('Identifier.count',0) {
		assert_difference('Pii.count',0) {
		assert_difference('StudySubject.count',0) {
#			candidate_control.create_study_subjects(case_study_subject)
		} } } }
	end

	test "should rollback if create_mother raises error" do
pending	#	TODO should test when create_mother fails
	end

	test "should rollback if assign_icf_master_id raises error" do
pending	#	TODO should test when assign_icf_master_id fails
	end

	#
	#	END: MANY subject creation tests
	#
	################################################################################

protected

	def create_study_subjects_for_candidate_control(candidate,case_subject)
		assert_difference('Enrollment.count',2) {	#	both get auto-created ccls enrollment
		assert_difference('Identifier.count',2) {
		assert_difference('Pii.count',2) {
		assert_difference('StudySubject.count',2) {
			candidate.create_study_subjects(case_subject)
		} } } }
	end

	def create_patient_for_subject(subject)
		patient = Factory(:patient, :study_subject => subject,
			:admit_date => 5.years.ago )
		assert_not_nil patient.admit_date
	end

#	def create_candidate_control(options={})
#		candidate_control = Factory.build(:candidate_control,options)
#		candidate_control.save
#		candidate_control
#	end

end
