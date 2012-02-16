require 'test_helper'

#	This is just a collection of duplicate related tests 
#	for StudySubject separated only for clarity due
#	to the size of the StudySubjectTest class.
class Ccls::StudySubjectDuplicatesTest < ActiveSupport::TestCase

	test "should respond to duplicates" do
		@duplicates = StudySubject.duplicates
		assert_no_duplicates_found
	end

	test "create_case_study_subject_for_duplicate_search test" do
		subject = create_case_study_subject_for_duplicate_search
		assert_equal subject.sex, 'M'
		assert_equal subject.subject_type, SubjectType['Case']
		assert_not_nil subject.dob
		assert_not_nil subject.patient
		assert_not_nil subject.admit_date
		assert_equal 'matchthis', subject.hospital_no
		assert_nil subject.mother_maiden_name
	end

	test "should return no subjects as duplicates with no params" do
		create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates
		assert_no_duplicates_found
	end

	test "should return no subjects as duplicates with minimal params" do
		create_case_study_subject_for_duplicate_search
		@duplicates = Factory.build(:study_subject).duplicates
		assert_no_duplicates_found
	end

#	All subjects:  Have the same birth date (piis.dob) and sex (subject.sex) as the new subject and 
#			(same mother’s maiden name or existing mother’s maiden name is null)

	test "should return subject as duplicate if has matching " <<
			"dob and sex and blank mother_maiden_names" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:sex => 'M',
			:dob => study_subject.dob )
		@duplicates = new_study_subject.duplicates
		assert_duplicates_found
	end

	test "should return subject as duplicate if has matching " <<
			"dob and sex and mother_maiden_name" do
		study_subject = create_case_study_subject_for_duplicate_search(
			:mother_maiden_name => 'Smith' )
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:sex => 'M', :dob => study_subject.dob, :mother_maiden_name => 'Smith' )
		@duplicates = new_study_subject.duplicates
		assert_duplicates_found
	end

	test "should return subject as duplicate if has matching " <<
			"dob and sex and existing mother_maiden_name is nil" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:sex => 'M', :dob => study_subject.dob, :mother_maiden_name => 'Smith' )
		@duplicates = new_study_subject.duplicates
		assert_duplicates_found
	end

	test "should return subject as duplicate if has matching " <<
			"dob and sex and existing mother_maiden_name is blank" do
		study_subject = create_case_study_subject_for_duplicate_search(
			:mother_maiden_name => '' )
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:sex => 'M', :dob => study_subject.dob, :mother_maiden_name => 'Smith' )
		@duplicates = new_study_subject.duplicates
		assert_duplicates_found
	end

	test "should NOT return subject as duplicate if has matching " <<
			"dob and sex and explicitly excluded" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:sex => 'M', :dob => study_subject.dob )
		@duplicates = new_study_subject.duplicates(:exclude_id => study_subject.id)
		assert_no_duplicates_found
	end

	test "should NOT return subject as duplicate if has matching " <<
			"dob and sex and differing mother_maiden_name" do
		study_subject = create_case_study_subject_for_duplicate_search(
			:mother_maiden_name => 'Smith' )
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:sex => 'M', :dob => study_subject.dob, :mother_maiden_name => 'Jones' )
		@duplicates = new_study_subject.duplicates
		assert_no_duplicates_found
	end

	test "should NOT return subject as duplicate if just has matching dob" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:dob => study_subject.dob )
		@duplicates = new_study_subject.duplicates
		assert_no_duplicates_found
	end

	test "should NOT return subject as duplicate if has matching dob and blank sex" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:sex => ' ', :dob => study_subject.dob )
		@duplicates = new_study_subject.duplicates
		assert_no_duplicates_found
	end

	test "should NOT return subject as duplicate if just has matching sex" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:sex => study_subject.sex )
		@duplicates = new_study_subject.duplicates
		assert_no_duplicates_found
	end

	test "should NOT return subject as duplicate if just matching sex and blank dob" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:sex => study_subject.sex, :dob => ' ' )
		@duplicates = new_study_subject.duplicates
		assert_no_duplicates_found
	end

#	Case subjects: Have the same hospital_no (patient.hospital_no) as the new subject
#	Only cases have a patient record, so not explicit check for Case is done.

	test "should return subject as duplicate if has matching hospital_no" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:patient_attributes => { :hospital_no => study_subject.hospital_no })
		@duplicates = new_study_subject.duplicates
		assert_duplicates_found
	end

	test "should NOT return subject as duplicate if has matching " <<
			"hospital_no and explicitly excluded" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:patient_attributes => { :hospital_no => study_subject.hospital_no })
		@duplicates = new_study_subject.duplicates(:exclude_id => study_subject.id)
		assert_no_duplicates_found
	end

#	Case subjects:  Are admitted the same admit date (patients.admit_date) at the same institution (patients.organization_id)
#	Only cases have a patient record, so not explicit check for Case is done.

	test "should return subject as duplicate if has matching " <<
			"admit_date and organization" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:patient_attributes => { 
				:admit_date => study_subject.admit_date,
				:organization_id => study_subject.organization_id })
		@duplicates = new_study_subject.duplicates
		assert_duplicates_found
	end

	test "should NOT return subject as duplicate if has matching " <<
			"admit_date and organization and explicitly excluded" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:patient_attributes => { 
				:admit_date => study_subject.admit_date,
				:organization_id => study_subject.organization_id })
		@duplicates = new_study_subject.duplicates(:exclude_id => study_subject.id)
		assert_no_duplicates_found
	end

	test "should NOT return subject as duplicate if just has matching admit_date" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:patient_attributes => { 
				:admit_date => study_subject.admit_date,
				:organization_id => '0' })
		@duplicates = new_study_subject.duplicates
		assert_no_duplicates_found
	end

	test "should NOT return subject as duplicate if has matching " <<
			"admit_date and blank organization_id" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:patient_attributes => { 
				:admit_date => study_subject.admit_date,
				:organization_id => ' ' })
		@duplicates = new_study_subject.duplicates
		assert_no_duplicates_found
	end

	test "should NOT return subject as duplicate if just has matching organization" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:patient_attributes => { 
				:organization_id => study_subject.organization_id })
		@duplicates = new_study_subject.duplicates
		assert_no_duplicates_found
	end

	test "should NOT return subject as duplicate if has matching " <<
			"organization and blank admit_date" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:patient_attributes => { 
				:admit_date => ' ',
				:organization_id => study_subject.organization_id })
		@duplicates = new_study_subject.duplicates
		assert_no_duplicates_found
	end

	test "should create operational event for raf duplicate" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:patient_attributes => { :hospital_no => study_subject.hospital_no })
		@duplicates = new_study_subject.duplicates
		assert_duplicates_found
		assert_difference('OperationalEvent.count',1) {
			study_subject.raf_duplicate_creation_attempted(new_study_subject)
		}
	end

#	class level duplicates search tests (used in candidate_control)

	test "class should return subject as duplicate if has matching " <<
			"admit_date and organization_id" do
		study_subject = create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates(
			:admit_date => study_subject.admit_date,
			:organization_id => study_subject.organization_id)
		assert_duplicates_found
	end

	test "class should NOT return subject as duplicate if has matching " <<
			"admit_date and organization_id if excluded" do
		study_subject = create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates(
			:exclude_id => study_subject.id,
			:admit_date => study_subject.admit_date,
			:organization_id => study_subject.organization_id)
		assert_no_duplicates_found
	end

	test "class should return subject as duplicate if has matching hospital_no" do
		study_subject = create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates(
			:hospital_no => study_subject.hospital_no )
		assert_duplicates_found
	end

	test "class should NOT return subject as duplicate if has matching " <<
			"hospital_no if excluded" do
		study_subject = create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates(
			:exclude_id => study_subject.id,
			:hospital_no => study_subject.hospital_no )
		assert_no_duplicates_found
	end

	test "class should return subject as duplicate if has matching " <<
			"sex, dob and mother_maiden_name" do
		study_subject = create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates(
			:sex => 'M',
			:dob => study_subject.dob,
			:mother_maiden_name => study_subject.mother_maiden_name )
		assert_duplicates_found
	end

	test "class should NOT return subject as duplicate if has matching " <<
			"sex, dob and mother_maiden_name if excluded" do
		study_subject = create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates(
			:exclude_id => study_subject.id,
			:sex => 'M',
			:dob => study_subject.dob,
			:mother_maiden_name => study_subject.mother_maiden_name )
		assert_no_duplicates_found
	end

	test "class should return subject as duplicate when all of these params " <<
			"are passed and all match" do
		study_subject = create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates(
			:mother_maiden_name => study_subject.mother_maiden_name,
			:hospital_no => study_subject.hospital_no,
			:sex => 'M',
			:dob => study_subject.dob,
			:admit_date => study_subject.admit_date,
			:organization_id => study_subject.organization_id)
		assert_duplicates_found
	end

	test "class should NOT return subject as duplicate when all of these params " <<
			"are passed and all match if excluded" do
		study_subject = create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates(
			:exclude_id => study_subject.id,
			:mother_maiden_name => study_subject.mother_maiden_name,
			:hospital_no => study_subject.hospital_no,
			:sex => 'M',
			:dob => study_subject.dob,
			:admit_date => study_subject.admit_date,
			:organization_id => study_subject.organization_id)
		assert_no_duplicates_found
	end

	test "class should NOT return subject as duplicate when all of these params " <<
			"are passed and none match" do
		study_subject = create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates(
			:mother_maiden_name => 'somethingdifferent',
			:hospital_no => 'somethingdifferent',
			:sex => 'F',
			:dob => Date.today,
			:admit_date => Date.today,
			:organization_id => 0 )
		assert_no_duplicates_found
	end

	test "class should NOT return subject as duplicate when all of these params " <<
			"are passed only sex matches" do
		study_subject = create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates(
			:mother_maiden_name => 'somethingdifferent',
			:hospital_no => 'somethingdifferent',
			:sex => 'M',
			:dob => Date.today,
			:admit_date => Date.today,
			:organization_id => 0 )
		assert_no_duplicates_found
	end

	test "class should NOT return subject as duplicate when all of these params " <<
			"are passed only dob matches" do
		study_subject = create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates(
			:mother_maiden_name => 'somethingdifferent',
			:hospital_no => 'somethingdifferent',
			:sex => 'F',
			:dob => study_subject.dob,
			:admit_date => Date.today,
			:organization_id => 0 )
		assert_no_duplicates_found
	end

	test "class should NOT return subject as duplicate when all of these params " <<
			"are passed only admit_date matches" do
		study_subject = create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates(
			:mother_maiden_name => 'somethingdifferent',
			:hospital_no => 'somethingdifferent',
			:sex => 'F',
			:dob => Date.today,
			:admit_date => study_subject.admit_date,
			:organization_id => 0 )
		assert_no_duplicates_found
	end

	test "class should NOT return subject as duplicate when all of these params " <<
			"are passed only organization matches" do
		study_subject = create_case_study_subject_for_duplicate_search
		@duplicates = StudySubject.duplicates(
			:mother_maiden_name => 'somethingdifferent',
			:hospital_no => 'somethingdifferent',
			:sex => 'F',
			:dob => Date.today,
			:admit_date => Date.today,
			:organization_id => study_subject.organization_id )
		assert_no_duplicates_found
	end

protected

	def assert_no_duplicates_found
		assert_not_nil @duplicates
		assert @duplicates.is_a?(Array)
		assert @duplicates.empty?
	end

	def assert_duplicates_found
		assert_not_nil @duplicates
		assert @duplicates.is_a?(Array)
		assert !@duplicates.empty?
	end

	def create_case_study_subject_for_duplicate_search(options={})
		Factory(:case_study_subject, { :sex => 'M',
			:dob => Date.yesterday,
			:patient_attributes => Factory.attributes_for(:patient,
				:hospital_no => 'matchthis',
				:admit_date => Date.yesterday ) }.deep_merge(options) )
	end

	def new_case_study_subject_for_duplicate_search(options={})
		Factory.build(:case_study_subject, { :sex => 'F',
			:dob => Date.today,
			:patient_attributes => Factory.attributes_for(:patient,
				:hospital_no => 'somethingdifferent',
#				:organization_id => 0,	#	Why 0? was for just matching admit_date
				:admit_date => Date.today ) }.deep_merge(options) )
	end

end
