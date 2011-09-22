require 'test_helper'

class Ccls::CandidateControlTest < ActiveSupport::TestCase
	
	assert_should_create_default_object
	assert_should_belong_to( :study_subject )
#	need to add test for this with booleans
#	assert_should_require_attributes( :reject_candidate )
##	assert_should_require_unique_attributes( :key, :code, :description )
	assert_should_not_require_attributes( 
		:icf_master_id,
		:related_patid,
		:first_name,
		:middle_name,
		:last_name,
		:dob,
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

#	Why 5?
#	assert_should_require_attribute_length( :related_patid, :is => 5 )
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




	test "should create study_subjects from attributes" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
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
#		puts object.study_subject.identifier.subjectid
	end

	test "should create control from attributes and add familyid" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		assert_not_nil object.study_subject.identifier.familyid
		assert_equal   object.study_subject.identifier.familyid.length, 6
#		puts object.study_subject.identifier.familyid
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

	test "should create control from attributes and add orderno" do
pending	#	TODO
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
#puts object.study_subject.identifier.orderno
#		assert_not_nil object.study_subject.identifier.orderno
	end

	test "should create control from attributes and add studyid" do
pending	#	TODO
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
#puts object.study_subject.identifier.studyid
#	TODO generated on the fly, NOT in the db (still missing orderno)
		assert_not_nil object.study_subject.identifier.studyid		
	end

	test "should create control from attributes and add icf_master_id" do
pending	#	TODO
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
#puts object.study_subject.identifier.icf_master_id
#		assert_not_nil object.study_subject.identifier.icf_master_id
	end

	test "should create mother from attributes" do
		case_study_subject = create_case_identifier.study_subject
		object = create_object
		create_study_subjects_for_candidate_control(object,case_study_subject)
		assert_not_nil object.study_subject.mother
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


protected

	def create_study_subjects_for_candidate_control(candidate,case_subject)
		assert_difference('Enrollment.count',1) {
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

end
