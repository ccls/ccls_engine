require 'test_helper'

class Ccls::CandidateControlTest < ActiveSupport::TestCase
	
	assert_should_create_default_object
	assert_should_belong_to( :study_subject )
	assert_should_require_attributes( 
		:first_name,
		:last_name,
		:dob )
	assert_should_not_require_attributes( 
		:icf_master_id,
		:related_patid,
		:middle_name,
		:state_registrar_no,
		:local_registrar_no,
		:sex,
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
		:sex,
		:birth_county,
		:birth_type,
		:mother_maiden_name,
		:rejection_reason,
			:maximum => 250 )

	test "should require rejection_reason if reject_candidate is true" do
		assert_difference("#{model_name}.count",0) {
			object = create_object(
				:reject_candidate => true,
				:rejection_reason => nil)
			assert object.errors.on_attr_and_type(:rejection_reason,:blank)
		}
	end

	test "should not require rejection_reason if reject_candidate is false" do
		assert_difference("#{model_name}.count",1) {
			object = create_object(
				:reject_candidate => false,
				:rejection_reason => nil)
		}
	end

	test "should require reject_candidate is not nil" do
		assert_difference("#{model_name}.count",0) {
			object = create_object(:reject_candidate => nil)
			assert object.errors.on_attr_and_type(:reject_candidate,:inclusion)
		}
	end

	test "should return join of candidate's name" do
		object = create_object(
			:first_name => "John",
			:last_name  => "Smith" )
		assert_equal 'John Smith', object.full_name 
	end

	################################################################################
	#
	#	BEGIN: MANY subject creation tests
	#

	test "should create study_subjects from attributes" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		object.reload	# ensure that it is saved in the db!
		assert_not_nil object.assigned_on
		assert_not_nil object.study_subject_id
	end

	test "should create control from attributes" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		assert_nil     object.study_subject.reference_date
	end

	test "should create control from attributes and copy case patid" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		control_subject = object.study_subject
		assert_not_nil control_subject.patid
		assert_equal   control_subject.patid, case_study_subject.patid
	end

	test "should create control from attributes and set hispanicity_id nil" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		control_subject = object.study_subject
		assert_nil control_subject.hispanicity_id
	end

	test "should create control from attributes and set hispanicity_id if father_hispanicity" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object( :father_hispanicity_id => 1 )
		create_study_subjects_for_candidate_control(object,case_study_subject)
		control_subject = object.study_subject
		assert_not_nil control_subject.hispanicity_id
		assert_equal   control_subject.hispanicity_id, 1
	end

	test "should create control from attributes and set hispanicity_id if mother_hispanicity" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object( :mother_hispanicity_id => 1 )
		create_study_subjects_for_candidate_control(object,case_study_subject)
		control_subject = object.study_subject
		assert_not_nil control_subject.hispanicity_id
		assert_equal   control_subject.hispanicity_id, 1
	end

	test "should create control from attributes with patient" do
		case_study_subject = create_case_identifier.study_subject
		create_patient_for_subject(case_study_subject)
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
	end

	test "should create control from attributes with patient and copy case admit_date" do
		case_study_subject = create_case_identifier.study_subject
		create_patient_for_subject(case_study_subject)
		case_study_subject.reload
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		control_subject = object.study_subject
		assert_not_nil control_subject.reference_date
		assert_equal   control_subject.reference_date, case_study_subject.patient.admit_date
	end

	test "should create control from attributes and add subjectid" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		assert_not_nil object.study_subject.identifier.subjectid
		assert_equal   object.study_subject.identifier.subjectid.length, 6
	end

	test "should create control from attributes and add familyid" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		assert_not_nil object.study_subject.identifier.familyid
		assert_equal   object.study_subject.identifier.familyid.length, 6
	end

	test "should create control from attributes and subjectid should equal familyid" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		assert_equal   object.study_subject.identifier.familyid, 
										object.study_subject.identifier.subjectid
	end

	test "should create control from attributes and copy case matchingid" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		assert_not_nil object.study_subject.identifier.matchingid
		assert_equal   object.study_subject.identifier.matchingid, 
									case_study_subject.identifier.matchingid
	end

	test "should create control from attributes and add orderno = 1" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		assert_not_nil object.study_subject.identifier.orderno
		assert_equal   object.study_subject.identifier.orderno, 1		#	As this will be the first control here
	end

	test "should create second control from attributes and add orderno = 2" do
		case_study_subject = create_case_identifier.study_subject
		object1 = create_object
		create_study_subjects_for_candidate_control(object1,case_study_subject)
		object2 = create_object
		create_study_subjects_for_candidate_control(object2,case_study_subject)
		assert_not_nil object2.study_subject.identifier.orderno
		assert_equal   object2.study_subject.identifier.orderno, 2		#	As this will be the second control here
	end

	test "should create control from attributes and add studyid" do
pending	#	TODO
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
#puts object.study_subject.identifier.studyid
#	TODO generated on the fly, NOT in the db
		assert_not_nil object.study_subject.identifier.studyid		
	end

	#	icf_master_id isn't required as may not have any
	test "should create control from attributes and add icf_master_id if any" do
		imi = Factory(:icf_master_id,:icf_master_id => '123456789')
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		assert_not_nil object.study_subject.identifier.icf_master_id
		assert_equal   object.study_subject.identifier.icf_master_id, '123456789'
		assert_not_nil imi.reload.study_subject
		assert_equal   imi.study_subject, object.study_subject
		assert_not_nil imi.assigned_on
		assert_equal   imi.assigned_on, Date.today
	end

	test "should create mother from attributes" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		assert_not_nil object.study_subject.mother
		mother = object.study_subject.mother
		assert_nil mother.identifier.case_control_type
		assert_nil mother.identifier.orderno
	end

	test "should create mother from attributes and NOT copy case patid" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		mother = object.study_subject.mother
		assert_nil mother.patid
	end

	test "should create mother from attributes with patient and copy case admit_date" do
		case_study_subject = create_case_identifier.study_subject
		create_patient_for_subject(case_study_subject)
		case_study_subject.reload
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		mother = object.study_subject.mother
		assert_not_nil mother.reference_date
		assert_equal   mother.reference_date, case_study_subject.patient.admit_date
	end

	test "should create mother from attributes and copy case matchingid" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		mother = object.study_subject.mother
		assert_not_nil mother.identifier.matchingid
		assert_equal   mother.identifier.matchingid, 
									case_study_subject.identifier.matchingid
	end

	test "should create mother from attributes and copy child familyid" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		mother = object.study_subject.mother
		assert_not_nil mother.identifier.familyid
		assert_equal   object.study_subject.identifier.familyid, 
										mother.identifier.familyid
	end

	#	icf_master_id isn't required as may not have any
	test "should create mother from attributes and add icf_master_id if any" do
		Factory(:icf_master_id,:icf_master_id => 'child')
		imi = Factory(:icf_master_id,:icf_master_id => '123456789')
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		assert_not_nil object.study_subject.mother.identifier.icf_master_id
		assert_equal   object.study_subject.mother.identifier.icf_master_id, '123456789'
		assert_not_nil imi.reload.study_subject
		assert_equal   imi.study_subject, object.study_subject.mother
		assert_not_nil imi.assigned_on
		assert_equal   imi.assigned_on, Date.today
	end

	test "should rollback study subject creation of icf_master_id save fails" do
pending #	TODO wrap in transaction.  Don't want this partially done.
		Factory(:icf_master_id,:icf_master_id => 'child')
		imi = Factory(:icf_master_id,:icf_master_id => '123456789')
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
#	none of these are actually stopping this!
#		IcfMasterId.any_instance.stubs(:create_or_update).returns(false)
#		IcfMasterId.any_instance.stubs(:valid?).returns(false)
#		IcfMasterId.any_instance.stubs(:save!).raises(ActiveRecord::RecordNotSaved)
		assert_difference('Enrollment.count',0) {
		assert_difference('Identifier.count',0) {
		assert_difference('Pii.count',0) {
		assert_difference('StudySubject.count',0) {
#			object.create_study_subjects(case_study_subject)
		} } } }
	end

	#
	#	END: MANY subject creation tests
	#
	################################################################################

protected

	def create_study_subjects_for_candidate_control(candidate,case_subject)
#	TODO mother's pii info not in candidate_control yet
		assert_difference('Enrollment.count',1) {
		assert_difference('Identifier.count',2) {
#		assert_difference('Pii.count',2) {	#	don't have enough info for mother's pii
		assert_difference('Pii.count',1) {
		assert_difference('StudySubject.count',2) {
			candidate.create_study_subjects(case_subject)
		} } } }
	end

	def create_patient_for_subject(subject)
		patient = Factory(:patient, :study_subject => subject,
			:admit_date => 5.years.ago )
		assert_not_nil patient.admit_date
	end

end
