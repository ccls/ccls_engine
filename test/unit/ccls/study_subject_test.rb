require 'test_helper'

class Ccls::StudySubjectTest < ActiveSupport::TestCase

	assert_should_create_default_object

#	Cannot in enrollments here due to the creation of one
#	during the creation of a study_subject
#	Should create custom check, but this is indirectly tested
#	in the creation of the enrollment so not really needed.
#		:enrollments,

	assert_should_have_many( :abstracts, :addressings, 
		:gift_cards, :phone_numbers, :samples, :interviews, :bc_requests )
	assert_should_initially_belong_to( :subject_type, :vital_status )
	assert_should_have_one( :home_exposure_response, :homex_outcome,
		:identifier, :pii )
	assert_should_habtm(:analyses)
	assert_requires_complete_date( :reference_date )
	assert_should_require_attributes_not_nil( :do_not_contact, :sex )
	assert_should_not_require_attributes( :vital_status_id, :hispanicity_id, 
		:reference_date, :mother_yrs_educ, :father_yrs_educ, 
		:birth_type, :birth_county, :is_duplicate_of )

	test "should require subject_type" do
		assert_difference( "StudySubject.count", 0 ) do
			study_subject = create_study_subject( :subject_type => nil)
			assert study_subject.errors.on(:subject_type)
		end
	end

	test "should require valid subject_type" do
		assert_difference( "StudySubject.count", 0 ) do
			study_subject = create_study_subject( :subject_type_id => 0)
			assert study_subject.errors.on(:subject_type)
		end
	end

	test "should require sex be either M, F or DK" do
		assert_difference( "StudySubject.count", 0 ) {
			study_subject = create_study_subject(:sex => 'X')
			assert study_subject.errors.on_attr_and_type(:sex,:inclusion)
		} 
	end

	test "should require sex with custom message" do
		assert_difference( "StudySubject.count", 0 ) do
			study_subject = create_study_subject( :sex => nil )
			assert study_subject.errors.on_attr_and_type(:sex,:blank)
			assert_match /No sex has been chosen/, 
				study_subject.errors.full_messages.to_sentence
			assert_no_match /Sex can't be blank/i, 
				study_subject.errors.full_messages.to_sentence
		end
	end

	test "create_control_study_subject should not create a subject type" do
		assert_difference( 'SubjectType.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_control_study_subject
			assert !study_subject.is_case?
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} }
	end

	test "create_case_study_subject should not create a subject type" do
		assert_difference( 'SubjectType.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_case_study_subject
			assert study_subject.is_case?
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should create study_subject" do
		assert_difference( 'VitalStatus.count', 1 ){
		assert_difference( 'SubjectType.count', 1 ){
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} } }
	end

	test "should create study_subject with language" do
		assert_difference( 'Language.count', 1 ){
		assert_difference( 'SubjectLanguage.count', 1 ){
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject
			study_subject.languages << Factory(:language)
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} } }
	end

	test "should create study_subject and accept_nested_attributes_for addressings" do
		assert_difference( 'Address.count', 1) {
		assert_difference( 'Addressing.count', 1) {
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject(
				:addressings_attributes => [Factory.attributes_for(:addressing,
					:address_attributes => Factory.attributes_for(:address,
					:address_type => AddressType['residence'] ) )])
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} } }
	end

	test "should create study_subject and ignore blank address" do
		assert_difference( 'Address.count', 0) {
		assert_difference( 'Addressing.count', 0) {
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject(
				:addressings_attributes => [Factory.attributes_for(:addressing,
					:address_attributes => { :address_type => AddressType['residence'] } )])
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} } }
	end

	test "should respond to residence_addresses_count" do
		study_subject = create_study_subject
		assert study_subject.respond_to?(:residence_addresses_count)
		assert_equal 0, study_subject.residence_addresses_count
		study_subject.update_attributes(
				:addressings_attributes => [Factory.attributes_for(:addressing,
					:address_attributes => Factory.attributes_for(:address,
					{ :address_type => AddressType['residence'] } ))])
		assert_equal 1, study_subject.reload.residence_addresses_count
		study_subject.update_attributes(
				:addressings_attributes => [Factory.attributes_for(:addressing,
					:address_attributes => Factory.attributes_for(:address,
					{ :address_type => AddressType['residence'] } ))])
		assert_equal 2, study_subject.reload.residence_addresses_count
	end

	test "should create study_subject and accept_nested_attributes_for phone_numbers" do
		assert_difference( 'PhoneNumber.count', 1) {
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject(
				:phone_numbers_attributes => [Factory.attributes_for(:phone_number,
					:phone_type_id => PhoneType['home'].id )])
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should create study_subject and ignore blank phone_number" do
		assert_difference( 'PhoneNumber.count', 0) {
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject(
				:phone_numbers_attributes => [Factory.attributes_for(:phone_number,
					:phone_number => '' )])
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should create study_subject and accept_nested_attributes_for enrollments" do
		assert_difference( 'Enrollment.count', 2) {	#	ccls enrollment is auto-created, so 2
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject(
				:enrollments_attributes => [Factory.attributes_for(:enrollment,
					:project_id => Project['non-specific'].id)])
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should create study_subject and accept_nested_attributes_for pii" do
		assert_difference( 'Pii.count', 1) {
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject(
				:pii_attributes => Factory.attributes_for(:pii))
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create study_subject with empty pii" do
		assert_difference( 'Pii.count', 0) {
		assert_difference( "StudySubject.count", 0 ) {
			study_subject = create_study_subject( :pii_attributes => {})
			assert study_subject.errors.on_attr_and_type('pii.dob',:blank)
		} }
	end

	test "should create study_subject and accept_nested_attributes_for homex_outcome" do
		assert_difference( 'HomexOutcome.count', 1) {
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject(
				:homex_outcome_attributes => Factory.attributes_for(:homex_outcome))
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create study_subject with empty homex_outcome" do
pending
		assert_difference( 'HomexOutcome.count', 0) {
		assert_difference( 'StudySubject.count', 0) {
#			study_subject = create_study_subject( :homex_outcome_attributes => {})
##			assert study_subject.errors.on('homex_outcome.state_id_no')	
#			puts study_subject.errors.inspect
		} }
	end

	test "should create case study_subject and accept_nested_attributes_for patient" do
		assert_difference( 'Patient.count', 1) {
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = Factory(:case_study_subject,
				:patient_attributes => Factory.attributes_for(:patient))
			assert  study_subject.is_case?
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create non-case study_subject with patient" do
		assert_difference( 'Patient.count', 0) {
		assert_difference( "StudySubject.count", 0 ) {
			study_subject = create_study_subject(
				:patient_attributes => Factory.attributes_for(:patient))
			assert !study_subject.is_case?
			assert study_subject.errors.on(:patient)	#	no type
			assert  study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should create patient for case study_subject" do
		assert_difference( 'Patient.count', 1) {
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = Factory(:case_study_subject)
			assert study_subject.is_case?
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
			patient = Factory(:patient, :study_subject => study_subject)
			assert !patient.new_record?, 
				"#{patient.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create patient for non-case study_subject" do
		assert_difference( 'Patient.count', 0) {
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject
			assert !study_subject.is_case?
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
			patient = Factory.build(:patient, :study_subject => study_subject)
			patient.save	#	avoid an exception being raised
			assert patient.errors.on(:study_subject)
		} }
	end

	test "should NOT create study_subject with empty patient" do
		assert_difference( 'Patient.count', 0) {
		assert_difference( "StudySubject.count", 0 ) {
			study_subject = create_study_subject( :patient_attributes => {})
			assert study_subject.errors.on('patient.diagnosis_id')
			assert study_subject.errors.on_attr_and_type('patient.diagnosis_id',:blank)
			assert study_subject.errors.on('patient.hospital_no')
			assert study_subject.errors.on_attr_and_type('patient.hospital_no',:blank)
			assert study_subject.errors.on('patient.admit_date')
			assert study_subject.errors.on_attr_and_type('patient.admit_date',:blank)
			assert study_subject.errors.on('patient.organization_id')
			assert study_subject.errors.on_attr_and_type('patient.organization_id',:blank)
		} }
	end

	test "should create study_subject and accept_nested_attributes_for identifier" do
		assert_difference( 'Identifier.count', 1) {
		assert_difference( 'StudySubject.count', 1) {
			study_subject = create_study_subject(
				:identifier_attributes => Factory.attributes_for(:identifier))
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} }
	end

#	nothing is required any longer, so this can happen
		test "should NOT create study_subject with empty identifier" do
pending	#	TODO will require something?
			assert_difference( 'Identifier.count', 0) {
			assert_difference( 'StudySubject.count', 0) {
#				study_subject = create_study_subject( :identifier_attributes => {} )
#	#			assert study_subject.errors.on_attr_and_type('identifier.orderno',:blank)
#	#			assert study_subject.errors.on_attr_and_type('identifier.patid',:blank)
#				assert study_subject.errors.on_attr_and_type('identifier.case_control_type',:blank)
#	#			assert study_subject.errors.on_attr_and_type('identifier.childid',:blank)
			} }
		end

	test "studyid should be patid, case_control_type and orderno" do
		Identifier.any_instance.stubs(:get_next_patid).returns('123')
		study_subject = Factory(:case_identifier).reload.study_subject
#	why unstub here
#		Identifier.any_instance.unstub(:get_next_patid)
		assert_nil study_subject.studyid
		assert_nil study_subject.identifier.studyid
		assert_nil study_subject.identifier.studyid_nohyphen
		assert_nil study_subject.identifier.studyid_intonly_nohyphen
pending	#	TODO gotta figure this out.  Studyids no longer computed
#		assert_equal "0123-C-0", study_subject.studyid
#		assert_equal "0123C0",   study_subject.identifier.studyid_nohyphen
#		assert_equal "012300",   study_subject.identifier.studyid_intonly_nohyphen
	end

	test "should belong to vital_status" do
		study_subject = create_study_subject(:vital_status => nil)
		assert_nil study_subject.vital_status
		study_subject.vital_status = Factory(:vital_status)
		assert_not_nil study_subject.vital_status
	end

#	test "should belong to hispanicity" do
#		study_subject = create_study_subject
#pending	#	TODO apparently hispanicity_id will just be a code
#		assert_nil study_subject.vital_status
#		study_subject.vital_status = Factory(:vital_status)
#		assert_not_nil study_subject.vital_status
#	end

#	test "should NOT destroy dust_kit with study_subject" do
#		study_subject = create_study_subject
#		Factory(:dust_kit, :study_subject => study_subject)
#		assert_difference('StudySubject.count',-1) {
#		assert_difference('DustKit.count',0) {
#			study_subject.destroy
#		} }
#	end

	test "should NOT destroy identifier with study_subject" do
		study_subject = create_study_subject
		Factory(:identifier, :study_subject => study_subject)
		assert_difference( "StudySubject.count", -1 ) {
		assert_difference('Identifier.count',0) {
			study_subject.destroy
		} }
	end

	test "should NOT destroy pii with study_subject" do
		study_subject = create_study_subject
		Factory(:pii, :study_subject => study_subject)
		assert_difference( "StudySubject.count", -1 ) {
		assert_difference('Pii.count',0) {
			study_subject.destroy
		} }
	end

	test "should NOT destroy patient with study_subject" do
		study_subject = Factory(:case_study_subject)
		Factory(:patient, :study_subject => study_subject)
		assert_difference( "StudySubject.count", -1 ) {
		assert_difference('Patient.count',0) {
			study_subject.destroy
		} }
	end

	test "should NOT destroy home_exposure_response with study_subject" do
		study_subject = Factory(:home_exposure_response).study_subject
		assert_difference( "StudySubject.count", -1 ) {
		assert_difference('HomeExposureResponse.count',0) {
			study_subject.destroy
		} }
	end

	test "should destroy addressings with study_subject" do
pending	#	TODO think should destroy addressings but NOT addresses
	end

#	Address belongs to addressing so address can be shared
#	Should destroy addressings though??
#	test "should NOT destroy addresses with study_subject" do
#		study_subject = create_study_subject
#		Factory(:address, :study_subject => study_subject)
#		Factory(:address, :study_subject => study_subject)
#		assert_difference('StudySubject.count',-1) {
#		assert_difference('Address.count',0) {
#			study_subject.destroy
#		} }
#	end

#	TODO	Why not?
#	test "should NOT destroy operational_events with study_subject" do
#		study_subject = create_study_subject
#		Factory(:operational_event, :study_subject => study_subject)
#		Factory(:operational_event, :study_subject => study_subject)
#		assert_difference('StudySubject.count',-1) {
#		assert_difference('OperationalEvent.count',0) {
#			study_subject.destroy
#		} }
#	end

#	TODO	Why not?
	test "should NOT destroy enrollments with study_subject" do
		study_subject = create_study_subject
		Factory(:enrollment, :study_subject => study_subject)
		Factory(:enrollment, :study_subject => study_subject)
		assert_difference( "StudySubject.count", -1 ) {
		assert_difference('Enrollment.count',0) {
			study_subject.destroy
		} }
	end

	test "should have and belong to many analyses" do
		study_subject = create_study_subject
		assert_equal 0, study_subject.analyses.length
		study_subject.analyses << Factory(:analysis)
		assert_equal 1, study_subject.reload.analyses.length
		study_subject.analyses << Factory(:analysis)
		assert_equal 2, study_subject.reload.analyses.length
	end

	test "should NOT destroy samples with study_subject" do
		study_subject = create_study_subject
		Factory(:sample, :study_subject => study_subject)
		Factory(:sample, :study_subject => study_subject)
		assert_difference( "StudySubject.count", -1 ) {
		assert_difference('Sample.count',0) {
			study_subject.destroy
		} }
	end

	#	All delegated fields
	%w( 
		admitting_oncologist admit_date organization 
			organization_id hospital_no
		patid orderno ssn childid state_id_no 
			state_registrar_no local_registrar_no
		first_name last_name mother_maiden_name
			initials fathers_name mothers_name email dob 
		interview_outcome sample_outcome
			interview_outcome_on sample_outcome_on 
		studyid full_name
		).each do |method_name|

		test "should respond to #{method_name}" do
			study_subject = create_study_subject
			assert study_subject.respond_to?(method_name)
		end

	end

	#	Delegated patient fields except ... admitting_oncologist
	%w( admit_date organization 
			organization_id hospital_no
		).each do |method_name|

		test "should return nil #{method_name} without patient" do
			study_subject = create_study_subject
			assert_nil study_subject.send(method_name)
		end

		test "should return #{method_name} with patient" do
			study_subject = create_study_subject(
				:patient_attributes => Factory.attributes_for(:patient))
			assert_not_nil study_subject.send(method_name)
		end

	end

	#	Mostly delegated identifier fields except ... patid, orderno
	%w( ssn childid state_id_no 
			state_registrar_no local_registrar_no
		).each do |method_name|

		test "should return nil #{method_name} without identifier" do
			study_subject = create_study_subject
			assert_nil study_subject.send(method_name)
		end

		test "should return #{method_name} with identifier" do
			study_subject = create_study_subject(
				:identifier_attributes => Factory.attributes_for(:identifier))
			assert_not_nil study_subject.send(method_name)
		end

	end

	#	Delegated pii fields except ... first_name, last_name, mother_maiden_name
	%w( initials fathers_name mothers_name email dob ).each do |method_name|

		test "should return nil #{method_name} without pii" do
			study_subject = create_study_subject
			assert_nil study_subject.send(method_name)
		end

		test "should return #{method_name} with pii" do
			study_subject = create_study_subject(
				:pii_attributes => Factory.attributes_for(:pii))
			assert_not_nil study_subject.send(method_name)
		end

	end

	#	Delegated homex_outcome fields except ... interview_outcome, sample_outcome
	%w( interview_outcome_on sample_outcome_on ).each do |method_name|

		test "should return nil #{method_name} without homex_outcome" do
			study_subject = create_study_subject
			assert_nil study_subject.send(method_name)
		end

		test "should return #{method_name} with homex_outcome" do
			study_subject = create_study_subject(
				:homex_outcome_attributes => Factory.attributes_for(:homex_outcome))
			assert_not_nil study_subject.send(method_name)
		end

	end

	test "should be ineligible for invitation without email" do
		study_subject = create_study_subject
		assert !study_subject.is_eligible_for_invitation?
	end

	test "should be eligible for invitation with email" do
		study_subject = create_study_subject(
			:pii_attributes => Factory.attributes_for(:pii))
		assert study_subject.is_eligible_for_invitation?
	end


#	TODO
#	test "should destroy patient on study_subject destroy" do
#		assert_difference( 'Patient.count', 1) {
#		assert_difference( 'StudySubject.count', 1) {
#			@study_subject = create_study_subject(
#				:patient_attributes => Factory.attributes_for(:patient))
#		} }
#		assert_difference( 'Patient.count', -1) {
#		assert_difference( 'StudySubject.count', -1) {
#			@study_subject.destroy
#		} }
#	end
#
#	test "should destroy dust_kit on study_subject destroy" do
#		assert_difference( 'DustKit.count', 1) {
#		assert_difference( 'StudySubject.count', 1) {
#			@study_subject = create_study_subject(
#				:dust_kit_attributes => Factory.attributes_for(:dust_kit))
#		} }
#		assert_difference( 'DustKit.count', -1) {
#		assert_difference( 'StudySubject.count', -1) {
#			@study_subject.destroy
#		} }
#	end
#
#	TODO
#	test "should destroy identifier on study_subject destroy" do
#		assert_difference( 'Identifier.count', 1) {
#		assert_difference( 'StudySubject.count', 1) {
#			@study_subject = create_study_subject(
#				:identifier_attributes => Factory.attributes_for(:identifier))
#		} }
#		assert_difference( 'Identifier.count', -1) {
#		assert_difference( 'StudySubject.count', -1) {
#			@study_subject.destroy
#		} }
#	end
#
#	TODO
#	test "should destroy pii on study_subject destroy" do
#		assert_difference( 'Pii.count', 1) {
#		assert_difference( 'StudySubject.count', 1) {
#			@study_subject = create_study_subject(
#				:pii_attributes => Factory.attributes_for(:pii))
#		} }
#		assert_difference( 'Pii.count', -1) {
#		assert_difference( 'StudySubject.count', -1) {
#			@study_subject.destroy
#		} }
#	end

	test "should return race name for string" do
		study_subject = create_study_subject
		assert_equal study_subject.race_names, 
			"#{study_subject.races.first}"
	end

	test "should return subject_type description for string" do
		study_subject = create_study_subject
		assert_equal study_subject.subject_type.description,
			"#{study_subject.subject_type}"
	end

	test "should return nil hx_enrollment if not enrolled" do
		study_subject = create_study_subject
		assert_nil study_subject.enrollments.find_by_project_id(
			Project['HomeExposures'].id)
	end

	test "should return valid hx_enrollment if enrolled" do
		study_subject = create_study_subject
		hxe = Factory(:enrollment,
			:study_subject => study_subject,
			:project => Project['HomeExposures']
		)
		assert_not_nil study_subject.enrollments.find_by_project_id(
			Project['HomeExposures'].id)
	end

	test "should not be case unless explicitly told" do
		study_subject = create_study_subject
		assert !study_subject.is_case?
	end

	test "should case if explicitly told" do
		study_subject = Factory(:case_study_subject)
		assert study_subject.is_case?
	end

	test "should not have hx_interview" do
		study_subject = create_study_subject
		assert_nil study_subject.hx_interview
	end

	test "should have hx_interview" do
		study_subject = create_hx_interview_study_subject
		assert_not_nil study_subject.hx_interview
	end

	test "should return concat of 3 fields as to_s" do
		study_subject = create_study_subject
		#	[childid,'(',studyid,full_name,')'].compact.join(' ')
		assert_equal "#{study_subject}",
			[study_subject.childid,'(',study_subject.studyid,study_subject.full_name,')'].compact.join(' ')
	end

	test "should return 'name not available' for study_subject without pii" do
		study_subject = create_study_subject
		assert_nil study_subject.pii
		assert_equal '[name not available]', study_subject.full_name
	end

	test "should return hx_id" do
		hx_id = Project['HomeExposures'].id
		assert_not_nil hx_id
		assert_equal StudySubject.hx_id, hx_id
	end

	test "should search for_hx" do
		study_subjects = StudySubject.for_hx()
		assert_not_nil study_subjects
		assert study_subjects.is_a?(Array)
	end

	test "should search for_hx_interview" do
		study_subjects = StudySubject.for_hx_interview()
		assert_not_nil study_subjects
		assert study_subjects.is_a?(Array)
	end

	test "should search need_gift_card" do
		study_subjects = StudySubject.need_gift_card()
		assert_not_nil study_subjects
		assert study_subjects.is_a?(Array)
	end

	test "should search for_hx_followup" do
		study_subjects = StudySubject.for_hx_followup()
		assert_not_nil study_subjects
		assert study_subjects.is_a?(Array)
	end

	test "should search for_hx_sample" do
		study_subjects = StudySubject.for_hx_sample()
		assert_not_nil study_subjects
		assert study_subjects.is_a?(Array)
	end

	test "should create study_subject with empty subject_languages_attributes" do
		assert_difference( 'SubjectLanguage.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_languages_attributes => { })
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert @study_subject.languages.empty?
		assert @study_subject.subject_languages.empty?
	end

	test "should create study_subject with blank language_id" do
		assert_difference( 'SubjectLanguage.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_languages_attributes => { 
				:some_random_id => { :language_id => '' }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert @study_subject.languages.empty?
		assert @study_subject.subject_languages.empty?
	end

	test "should create study_subject with subject_languages_attributes language_id" do
		assert Language.count > 0
		assert_difference( 'SubjectLanguage.count', 1 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_languages_attributes => {
				:some_random_id => { :language_id => Language.first.id }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert !@study_subject.languages.empty?
		assert_equal 1, @study_subject.languages.length
		assert !@study_subject.subject_languages.empty?
		assert_equal 1, @study_subject.subject_languages.length
	end

	test "should create study_subject with subject_languages_attributes multiple languages" do
		assert Language.count > 1
		languages = Language.all
		assert_difference( 'SubjectLanguage.count', 2 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_languages_attributes => {
				:some_random_id1 => { :language_id => languages[0].id },
				:some_random_id2 => { :language_id => languages[1].id }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert !@study_subject.languages.empty?
		assert_equal 2, @study_subject.languages.length
		assert !@study_subject.subject_languages.empty?
		assert_equal 2, @study_subject.subject_languages.length
	end

	test "should NOT create study_subject with subject_languages_attributes " <<
			"if language is other and no other given" do
		assert Language.count > 0
		assert_difference( 'SubjectLanguage.count', 0 ){
		assert_difference( "StudySubject.count", 0 ) {
			@study_subject = create_study_subject(:subject_languages_attributes => {
				:some_random_id => { :language_id => Language['other'].id }
			})
			assert @study_subject.errors.on_attr_and_type("subject_languages.other",:blank)
		} }
	end


	test "should create study_subject with empty subject_races_attributes" do
		assert_difference( 'SubjectRace.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => { })
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert @study_subject.races.empty?
		assert @study_subject.subject_races.empty?
	end

	test "should create study_subject with blank race_id" do
		assert_difference( 'SubjectRace.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => { 
				:some_random_id => { :race_id => '' }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert @study_subject.races.empty?
		assert @study_subject.subject_races.empty?
	end

	test "should create study_subject with subject_races_attributes race_id" do
		assert Race.count > 0
		assert_difference( 'SubjectRace.count', 1 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => {
				:some_random_id => { :race_id => Race.first.id }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert !@study_subject.races.empty?
		assert !@study_subject.subject_races.empty?
		assert !@study_subject.subject_races.first.is_primary
	end

	test "should create study_subject with subject_races_attributes race_id and is_primary" do
		assert Race.count > 0
		assert_difference( 'SubjectRace.count', 1 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => {
				:some_random_id => { :race_id => Race.first.id, :is_primary => 'true' }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert !@study_subject.races.empty?
		assert !@study_subject.subject_races.empty?
		assert  @study_subject.subject_races.first.is_primary
	end

	test "should create study_subject with subject_races_attributes multiple races" do
		assert Race.count > 2
		races = Race.all
		assert_difference( 'SubjectRace.count', 3 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => {
				:some_random_id1 => { :race_id => races[1].id },
				:some_random_id2 => { :race_id => races[2].id },
				:some_random_id3 => { :race_id => races[3].id }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert !@study_subject.races.empty?
		assert_equal 3, @study_subject.races.length
		assert !@study_subject.subject_races.empty?
		assert_equal 3, @study_subject.subject_races.length
		assert !@study_subject.subject_races.collect(&:is_primary).any?
	end

	test "should create study_subject with subject_races_attributes multiple races and is_primaries" do
		assert Race.count > 2
		races = Race.all
		assert_difference( 'SubjectRace.count', 3 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => {
				:some_random_id1 => { :race_id => races[1].id, :is_primary => 'true' },
				:some_random_id2 => { :race_id => races[2].id, :is_primary => 'true' },
				:some_random_id3 => { :race_id => races[3].id, :is_primary => 'true' }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert !@study_subject.races.empty?
		assert_equal 3, @study_subject.races.length
		assert !@study_subject.subject_races.empty?
		assert_equal 3, @study_subject.subject_races.length
		assert  @study_subject.subject_races.collect(&:is_primary).all?
	end

	test "should create study_subject with subject_races_attributes with is_primary and no race_id" do
		assert Race.count > 0
		assert_difference( 'SubjectRace.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_races_attributes => {
				:some_random_id => { :is_primary => 'true' }
			})
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert @study_subject.races.empty?
		assert @study_subject.subject_races.empty?
	end

	test "should update study_subject with subject_races_attributes" do
		assert Race.count > 0
		assert_difference( 'SubjectRace.count', 0 ){
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject
			assert !@study_subject.new_record?, 
				"#{@study_subject.errors.full_messages.to_sentence}"
		} }
		assert @study_subject.races.empty?
		assert @study_subject.subject_races.empty?
		assert_difference( 'SubjectRace.count', 1 ){
		assert_difference( "StudySubject.count", 0 ) {
			@study_subject.update_attributes(:subject_races_attributes => {
				:some_random_id => { :race_id => Race.first.id, :is_primary => 'true' }
			})
		} }
		assert !@study_subject.races.empty?
		assert !@study_subject.subject_races.empty?
		assert  @study_subject.subject_races.first.is_primary
	end

	test "should raise StudySubject::NotTwoAbstracts with 0 abstracts on abstracts_the_same?" do
		study_subject = Factory(:study_subject)
		assert_equal 0, study_subject.abstracts.length
		assert_raise(StudySubject::NotTwoAbstracts) {
			study_subject.abstracts_the_same?
		}
	end

	test "should raise StudySubject::NotTwoAbstracts with 1 abstracts on abstracts_the_same?" do
		study_subject = Factory(:study_subject)
		Factory(:abstract, :study_subject => study_subject)
		study_subject.reload
		assert_equal 1, study_subject.abstracts.length
		assert_raise(StudySubject::NotTwoAbstracts) {
			study_subject.abstracts_the_same?
		}
	end

	test "should return true if abstracts are the same on abstracts_the_same?" do
		study_subject = Factory(:study_subject)
		Factory(:abstract, :study_subject => study_subject)
		Factory(:abstract, :study_subject => study_subject)
		study_subject.reload
		assert_equal 2, study_subject.abstracts.length
		assert study_subject.abstracts_the_same?
	end

	test "should raise StudySubject::NotTwoAbstracts with 3 abstracts on abstracts_the_same?" do
		study_subject = Factory(:study_subject)
		Factory(:abstract, :study_subject => study_subject)
		Factory(:abstract, :study_subject => study_subject)
		Factory(:abstract, :study_subject => study_subject)
		study_subject.reload
		assert_equal 3, study_subject.abstracts.length
		assert_raise(StudySubject::NotTwoAbstracts) {
			study_subject.abstracts_the_same?
		}
	end

	test "should raise StudySubject::NotTwoAbstracts with 0 abstracts on abstract_diffs" do
		study_subject = Factory(:study_subject)
		assert_equal 0, study_subject.abstracts.length
		assert_raise(StudySubject::NotTwoAbstracts) {
			study_subject.abstract_diffs
		}
	end

	test "should raise StudySubject::NotTwoAbstracts with 1 abstracts on abstract_diffs" do
		study_subject = Factory(:study_subject)
		Factory(:abstract, :study_subject => study_subject)
		study_subject.reload
		assert_equal 1, study_subject.abstracts.length
		assert_raise(StudySubject::NotTwoAbstracts) {
			study_subject.abstract_diffs
		}
	end

	test "should return true if abstracts are the same on abstract_diffs" do
		study_subject = Factory(:study_subject)
		Factory(:abstract, :study_subject => study_subject)
		Factory(:abstract, :study_subject => study_subject)
		study_subject.reload
		assert_equal 2, study_subject.abstracts.length
		assert_equal Hash.new, study_subject.abstract_diffs
		assert       study_subject.abstract_diffs.empty?
	end

	test "should raise StudySubject::NotTwoAbstracts with 3 abstracts on abstract_diffs" do
		study_subject = Factory(:study_subject)
		Factory(:abstract, :study_subject => study_subject)
		Factory(:abstract, :study_subject => study_subject)
		Factory(:abstract, :study_subject => study_subject)
		study_subject.reload
		assert_equal 3, study_subject.abstracts.length
		assert_raise(StudySubject::NotTwoAbstracts) {
			study_subject.abstract_diffs
		}
	end


	test "should set study_subject.reference_date to self.patient.admit_date on create" do
		create_case_study_subject_with_patient_and_identifier
	end

	test "should update all matching study_subjects' reference date " <<
			"with updated admit date" do
		study_subject = create_case_study_subject(
			:patient_attributes    => Factory.attributes_for(:patient),
			:identifier_attributes => Factory.attributes_for(:identifier,
				{ :matchingid => '12345' })).reload
		other   = create_study_subject_with_matchingid
		nobody  = create_study_subject_with_matchingid('54321')
#	admit_date is now required, so will exist initially
#		assert_nil study_subject.reference_date
#		assert_nil study_subject.patient.admit_date
#		assert_nil other.reference_date
		assert_nil nobody.reference_date
		study_subject.patient.update_attributes(
			:admit_date => Chronic.parse('yesterday'))
		assert_not_nil study_subject.patient.admit_date
		assert_not_nil study_subject.reload.reference_date
		assert_not_nil other.reload.reference_date
		assert_nil     nobody.reload.reference_date
		assert_equal study_subject.reference_date, study_subject.patient.admit_date
		assert_equal study_subject.reference_date, other.reference_date
	end

	test "should set study_subject.reference_date to matching patient.admit_date " <<
			"on create with patient created first" do
		study_subject = create_case_study_subject_with_patient_and_identifier
		other   = create_study_subject_with_matchingid
		assert_not_nil other.reference_date
		assert_equal   other.reference_date, study_subject.reference_date
		assert_equal   other.reference_date, study_subject.patient.admit_date
	end

	test "should set study_subject.reference_date to matching patient.admit_date " <<
			"on create with patient created last" do
		other   = create_study_subject_with_matchingid
		study_subject = create_case_study_subject_with_patient_and_identifier
		assert_not_nil other.reload.reference_date
		assert_equal   other.reference_date, study_subject.reference_date
		assert_equal   other.reference_date, study_subject.patient.admit_date
	end

	test "should nullify study_subject.reference_date if matching patient changes matchingid" do
		other   = create_study_subject_with_matchingid
		study_subject = create_case_study_subject_with_patient_and_identifier
		assert_not_nil other.reload.reference_date
		study_subject.identifier.update_attributes(:matchingid => '12346')
		assert_nil     other.reload.reference_date
	end

	test "should nullify study_subject.reference_date if matching patient nullifies matchingid" do
		other   = create_study_subject_with_matchingid
		study_subject = create_case_study_subject_with_patient_and_identifier
		assert_not_nil other.reload.reference_date
		study_subject.identifier.update_attributes(:matchingid => nil)
		assert_nil     other.reload.reference_date
	end

	test "should nullify study_subject.reference_date if matching patient nullifies admit_date (admit_date now required)" do
		other   = create_study_subject_with_matchingid
		study_subject = create_case_study_subject_with_patient_and_identifier
		assert_not_nil study_subject.patient.admit_date
		assert_not_nil study_subject.reference_date
		assert_not_nil other.reload.reference_date
#	admit_date is now required, so can't nullify admit_date
#	This actually now returns false
		assert !study_subject.patient.update_attributes(:admit_date => nil)
		assert_not_nil study_subject.patient.reload.admit_date
		assert_not_nil study_subject.reference_date
		assert_not_nil other.reload.reference_date
#		assert_nil     other.reload.reference_date
	end

	test "should create_home_exposure_with_study_subject" do
		study_subject = create_home_exposure_with_study_subject
		assert study_subject.is_a?(StudySubject)
	end

	test "should create_home_exposure_with_study_subject with patient" do
		study_subject = create_home_exposure_with_study_subject(:patient => true)
		assert study_subject.is_a?(StudySubject)
	end

	test "should not require dob on creation for father with flag" do
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_type => SubjectType['Father'],
				:pii_attributes => Factory.attributes_for(:pii,
					:subject_is_father => true,
					:dob => nil )
			)
		}
		assert_nil @study_subject.reload.dob
	end

	test "should not require dob on update for father" do
		#	flag not necessary as study_subject.subject_type exists
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_type => SubjectType['Father'],
				:pii_attributes => Factory.attributes_for(:pii) )
		}
		assert_not_nil @study_subject.reload.dob
		@study_subject.pii.update_attributes(:dob => nil)
		assert_nil @study_subject.reload.dob
	end

	test "should not require dob on creation for mother with flag" do
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_type => SubjectType['Mother'],
				:pii_attributes => Factory.attributes_for(:pii,
					:subject_is_mother => true,
					:dob => nil )
			)
		}
		assert_nil @study_subject.reload.dob
	end

	test "should not require dob on update for mother" do
		#	flag not necessary as study_subject.subject_type exists
		assert_difference( "StudySubject.count", 1 ) {
			@study_subject = create_study_subject(:subject_type => SubjectType['Mother'],
				:pii_attributes => Factory.attributes_for(:pii) )
		}
		assert_not_nil @study_subject.reload.dob
		@study_subject.pii.update_attributes(:dob => nil)
		assert_nil @study_subject.reload.dob
	end

	test "should return SOMETHING for next_control_orderno for control" do
		study_subject = create_identifier.study_subject
#		assert_equal 1, case_study_subject.next_control_orderno
pending	#	TODO 
	end

	test "should return 1 for next_control_orderno for case with no controls" do
		case_study_subject = create_case_identifier.study_subject
		assert_equal 1, case_study_subject.next_control_orderno
	end

	test "should return 2 for next_control_orderno for case with one control" do
		case_study_subject = create_case_identifier.study_subject
		assert_equal 1, case_study_subject.next_control_orderno
		control = create_control_identifier(
			:matchingid => case_study_subject.identifier.subjectid,
			:case_control_type => '6',	#	<- default used for next_control_orderno
			:orderno    => case_study_subject.next_control_orderno ).study_subject
		assert_equal 2, case_study_subject.next_control_orderno
	end

	test "should not assign icf_master_id when there are none" do
		study_subject = create_identifier(:icf_master_id => nil).study_subject
		study_subject.assign_icf_master_id
		assert_nil study_subject.identifier.icf_master_id
	end

	test "should not assign icf_master_id if already have one and one exists" do
		study_subject = create_identifier.study_subject
		imi = Factory(:icf_master_id,:icf_master_id => '123456789')
		icf_master_id = study_subject.identifier.reload.icf_master_id
		assert_not_nil icf_master_id
		study_subject.assign_icf_master_id
		assert_equal icf_master_id, study_subject.identifier.reload.icf_master_id
	end

	test "should assign icf_master_id when there is one" do
		study_subject = create_identifier(:icf_master_id => nil).study_subject
		imi = Factory(:icf_master_id,:icf_master_id => '123456789')
		study_subject.assign_icf_master_id
		assert_not_nil study_subject.identifier.icf_master_id
		assert_equal '123456789', study_subject.identifier.icf_master_id
		imi.reload
		assert_not_nil imi.assigned_on
		assert_equal Date.today, imi.assigned_on
		assert_not_nil imi.study_subject_id
		assert_equal imi.study_subject_id, study_subject.id
	end

	test "should create mother when isn't one" do
		study_subject = create_identifier.study_subject
		assert_nil study_subject.reload.mother
		assert_difference('Pii.count',1) {
		assert_difference('Identifier.count',1) {
		assert_difference('StudySubject.count',1) {
			@mother = study_subject.create_mother
		} } }
		assert_equal @mother, study_subject.mother
	end

	test "should not create mother when one exists" do
		study_subject = create_identifier.study_subject
		mother = study_subject.create_mother
		assert_difference('Pii.count',0) {
		assert_difference('Identifier.count',0) {
		assert_difference('StudySubject.count',0) {
			@mother = study_subject.create_mother
		} } }
		assert_equal @mother, mother
	end

	test "should not create mother for mother" do
pending	#	TODO should it?  doubt it.
	end

	test "should assign icf_master_id to mother on creation if one exists" do
		study_subject = create_identifier(:icf_master_id => nil).study_subject
		imi = Factory(:icf_master_id,:icf_master_id => '123456789')
		mother = study_subject.create_mother
		assert_not_nil mother.reload.identifier.icf_master_id
		assert_equal '123456789', mother.identifier.icf_master_id
	end

	test "should not assign icf_master_id to mother on creation if none exist" do
		study_subject = create_identifier(:icf_master_id => nil).study_subject
		mother = study_subject.create_mother
		assert_nil mother.reload.identifier.icf_master_id
	end

	test "should return 'no ID assigned' if study_subject has no icf_master_id" do
		study_subject = create_identifier(:icf_master_id => nil).study_subject
		assert_nil     study_subject.identifier.icf_master_id
		assert_not_nil study_subject.icf_master_id
		assert_equal   study_subject.icf_master_id, '[no ID assigned]'
	end

	test "should return icf_master_id if study_subject has icf_master_id" do
		study_subject = create_identifier.study_subject
		assert_not_nil study_subject.identifier.icf_master_id
		assert_not_nil study_subject.icf_master_id
		assert_equal   study_subject.icf_master_id, study_subject.identifier.icf_master_id
	end

	test "should create father when isn't one" do
		study_subject = create_identifier.study_subject
		assert_nil study_subject.reload.father
		assert_difference('Pii.count',1) {
		assert_difference('Identifier.count',1) {
		assert_difference('StudySubject.count',1) {
			@father = study_subject.create_father
		} } }
		assert_equal @father, study_subject.father
	end

	test "should not create father when one exists" do
		study_subject = create_identifier.study_subject
		father = study_subject.create_father
		assert_difference('Pii.count',0) {
		assert_difference('Identifier.count',0) {
		assert_difference('StudySubject.count',0) {
			@father = study_subject.create_father
		} } }
		assert_equal @father, father
	end

	test "should not create father for father" do
pending	#	TODO should it?  doubt it.
	end

	test "should assign icf_master_id to father on creation if one exists" do
		study_subject = create_identifier(:icf_master_id => nil).study_subject
		imi = Factory(:icf_master_id,:icf_master_id => '123456789')
		father = study_subject.create_father
		assert_not_nil father.reload.identifier.icf_master_id
		assert_equal '123456789', father.identifier.icf_master_id
	end

	test "should not assign icf_master_id to father on creation if none exist" do
		study_subject = create_identifier(:icf_master_id => nil).study_subject
		father = study_subject.create_father
		assert_nil father.reload.identifier.icf_master_id
	end

	test "should get control subjects if case" do
		study_subject = create_case_identifier.study_subject
		study_subject.controls
pending #	TODO add controls method, check if case, ...
	end

	test "should do what for control subjects if not case" do
		study_subject = create_identifier.study_subject
		study_subject.controls
pending #	TODO add controls method, check if case, ...
	end

	test "should NOT include self in family" do
		study_subject = create_identifier.study_subject.reload
		assert_equal 0, study_subject.family.length
	end

	test "should NOT include self in matching" do
		study_subject = create_identifier.study_subject.reload
		assert_equal 0, study_subject.matching.length
	end

	test "should include mother in family" do
		study_subject = create_identifier.study_subject.reload
		mother = study_subject.create_mother
		assert_equal      1, study_subject.family.length
		assert_equal mother, study_subject.family.last
	end

	test "should include father in family" do
		study_subject = create_identifier.study_subject.reload
		father = study_subject.create_father
		assert_equal      1, study_subject.family.length
		assert_equal father, study_subject.family.last
	end

#	I think that matchingid is only for matching controls with cases
	test "should include mother in matching for case" do
#	TODO what if matchingid is null (as is for non-case)?
		study_subject = create_case_identifier.study_subject.reload
		mother = study_subject.create_mother
		assert_equal      1, study_subject.matching.length
		assert_equal mother, study_subject.matching.last
	end

	test "should include father in matching for case" do
#	TODO what if matchingid is null (as is for non-case)?
		study_subject = create_case_identifier.study_subject.reload
		father = study_subject.create_father
		assert_equal      1, study_subject.matching.length
		assert_equal father, study_subject.matching.last
	end

	test "should do what for null matchingid for matching" do
pending	#	TODO should do what for null matchingid for matching
	end

	test "should do what for null familyid for family" do
pending	#	TODO should do what for null familyid for family
	end

	test "should return mother if is one" do
		study_subject = create_identifier.study_subject.reload
		assert_nil study_subject.mother
		mother = study_subject.create_mother
		assert_not_nil study_subject.mother
		assert_equal mother, study_subject.mother
	end

	test "should return father if is one" do
		study_subject = create_identifier.study_subject.reload
		assert_nil study_subject.father
		father = study_subject.create_father
		assert_not_nil study_subject.father
		assert_equal father, study_subject.father
	end

	test "should return rejected controls for case" do
		study_subject = create_case_identifier.study_subject
		study_subject.rejected_controls
pending #	TODO should return rejected controls for case
	end

	test "should return what for rejected controls for non-case" do
		study_subject = create_identifier.study_subject
		study_subject.rejected_controls
pending #	TODO should return what for rejected controls for non-case
	end

	test "should respond to duplicates" do
		@duplicates = StudySubject.duplicates
		assert_no_duplicates_found
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

	test "should return subject as duplicate if has matching dob and sex" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:sex => 'M',
			:pii_attributes => { :dob => study_subject.dob } )
		@duplicates = new_study_subject.duplicates
		assert_duplicates_found
	end

	test "should NOT return subject as duplicate if just has matching dob" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:pii_attributes => { :dob => study_subject.dob } )
		@duplicates = new_study_subject.duplicates
		assert_no_duplicates_found
	end

	test "should NOT return subject as duplicate if has matching dob and blank sex" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:sex => ' ', :pii_attributes => { :dob => study_subject.dob } )
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
			:sex => study_subject.sex, :pii_attributes => { :dob => ' ' } )
		@duplicates = new_study_subject.duplicates
		assert_no_duplicates_found
	end

	test "should return subject as duplicate if has matching hospital_no" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:patient_attributes => { :hospital_no => study_subject.hospital_no })
		@duplicates = new_study_subject.duplicates
		assert_duplicates_found
	end

	test "should return subject as duplicate if has matching admit_date and organization" do
		study_subject = create_case_study_subject_for_duplicate_search
		new_study_subject = new_case_study_subject_for_duplicate_search(
			:patient_attributes => { 
				:admit_date => study_subject.admit_date,
				:organization_id => study_subject.organization_id })
		@duplicates = new_study_subject.duplicates
		assert_duplicates_found
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

	test "should NOT return subject as duplicate if has matching admit_date and blank organization_id" do
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

	test "should NOT return subject as duplicate if has matching organization and blank admit_date" do
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

#	test "should return subject as duplicate when all of these params are passed and all match" do
#		study_subject = create_case_study_subject_for_duplicate_search
#		@duplicates = StudySubject.duplicates(
#			:hospital_no => study_subject.hospital_no,
#			:sex => 'M',
#			:dob => study_subject.dob,
#			:admit_date => study_subject.admit_date,
#			:organization_id => study_subject.organization_id)
#		assert_duplicates_found
#	end
#
#	test "should NOT return subject as duplicate when all of these params are passed and none match" do
#		study_subject = create_case_study_subject_for_duplicate_search
#		@duplicates = StudySubject.duplicates(
#			:hospital_no => 'somethingdifferent',
#			:sex => 'F',
#			:dob => Date.today,
#			:admit_date => Date.today,
#			:organization_id => 0 )
#		assert_no_duplicates_found
#	end
#
#	test "should NOT return subject as duplicate when all of these params are passed only sex matches" do
#		study_subject = create_case_study_subject_for_duplicate_search
#		@duplicates = StudySubject.duplicates(
#			:hospital_no => 'somethingdifferent',
#			:sex => 'M',
#			:dob => Date.today,
#			:admit_date => Date.today,
#			:organization_id => 0 )
#		assert_no_duplicates_found
#	end
#
#	test "should NOT return subject as duplicate when all of these params are passed only dob matches" do
#		study_subject = create_case_study_subject_for_duplicate_search
#		@duplicates = StudySubject.duplicates(
#			:hospital_no => 'somethingdifferent',
#			:sex => 'F',
#			:dob => study_subject.dob,
#			:admit_date => Date.today,
#			:organization_id => 0 )
#		assert_no_duplicates_found
#	end
#
#	test "should NOT return subject as duplicate when all of these params are passed only admit_date matches" do
#		study_subject = create_case_study_subject_for_duplicate_search
#		@duplicates = StudySubject.duplicates(
#			:hospital_no => 'somethingdifferent',
#			:sex => 'F',
#			:dob => Date.today,
#			:admit_date => study_subject.admit_date,
#			:organization_id => 0 )
#		assert_no_duplicates_found
#	end
#
#	test "should NOT return subject as duplicate when all of these params are passed only organization matches" do
#		study_subject = create_case_study_subject_for_duplicate_search
#		@duplicates = StudySubject.duplicates(
#			:hospital_no => 'somethingdifferent',
#			:sex => 'F',
#			:dob => Date.today,
#			:admit_date => Date.today,
#			:organization_id => study_subject.organization_id )
#		assert_no_duplicates_found
#	end

	test "should return case by patid" do
		Factory(:case_study_subject)	#	just another for noise
		study_subject = Factory(:case_identifier).study_subject
		found_study_subject = StudySubject.find_case_by_patid(study_subject.patid)
		assert_not_nil found_study_subject
		assert_equal study_subject, found_study_subject
	end

	test "should return nothing if no case matching patid" do
		study_subject = Factory(:case_identifier).study_subject
		found_study_subject = StudySubject.find_case_by_patid('0000')
		assert_nil found_study_subject
	end

	test "should return child if subject is mother" do
		study_subject = create_identifier.study_subject.reload
		mother = study_subject.create_mother
		assert_equal mother, study_subject.mother
		assert_equal mother.child, study_subject
	end

	test "should return nil for child if is not mother" do
		study_subject = create_identifier.study_subject.reload
		assert_nil study_subject.child
	end

	test "should return appended child's childid if is mother" do
		study_subject = create_identifier.study_subject.reload
		mother = study_subject.create_mother
		assert_not_nil study_subject.childid
		assert_nil     mother.identifier.childid
		assert_not_nil mother.childid
		assert_equal "#{study_subject.childid} (mother)", mother.childid
	end

	test "should return nil for subjects without studyid" do
		study_subject = create_identifier.study_subject.reload
		assert_nil study_subject.studyid
	end

	test "should return n/a for mother's studyid" do
		study_subject = create_identifier.study_subject.reload
		mother = study_subject.create_mother
		assert_equal 'n/a', mother.studyid
	end

	test "should create ccls project enrollment on creation" do
		study_subject = nil
		assert_difference('Project.count',0) {	#	make sure it didn't create id
		assert_difference('Enrollment.count',1) {
		assert_difference('StudySubject.count',1) {
			study_subject = create_study_subject
		} } }
		assert_not_nil study_subject.enrollments.find_by_project_id(Project['ccls'].id)
	end

	test "should only create 1 ccls project enrollment on creation if given one" do
		study_subject = nil
		assert_difference('Project.count',0) {	#	make sure it didn't create id
		assert_difference('Enrollment.count',1) {
		assert_difference('StudySubject.count',1) {
			study_subject = create_study_subject(:enrollments_attributes => [
				{ :project_id => Project['ccls'].id }
			])
		} } }
		assert_not_nil study_subject.enrollments.find_by_project_id(Project['ccls'].id)
	end

	test "should create newSubject operational event on creation" do
		study_subject = nil
		assert_difference('OperationalEventType.count',0) {	#	make sure it didn't create it
		assert_difference('OperationalEvent.count',1) {
		assert_difference('StudySubject.count',1) {
			study_subject = create_study_subject
		} } }
		ccls_enrollment = study_subject.enrollments.find_by_project_id(Project['ccls'].id)
		assert_not_nil ccls_enrollment
		assert_not_nil ccls_enrollment.operational_events.find_by_operational_event_type_id(
			OperationalEventType['newSubject'].id )
	end

	test "should create subjectDied operational event when vital status changed to deceased" do
		study_subject = create_study_subject.reload		#	reload.  sometimes you need it?
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

	test "complete case study subject factory test" do
		assert_difference('Pii.count',1) {
		assert_difference('Patient.count',1) {
		assert_difference('Identifier.count',1) {
		assert_difference('StudySubject.count',1) {
			s = Factory(:complete_case_study_subject)
			assert_equal s.subject_type, SubjectType['Case']
			assert_equal s.identifier.case_control_type, 'C'
			assert_equal s.identifier.orderno, 0
			assert_not_nil s.identifier.childid
			assert_not_nil s.identifier.patid
		} } } }
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

	def create_study_subject(options={})
		study_subject = Factory.build(:study_subject,options)
		study_subject.save
		study_subject
	end

	def create_study_subject_with_matchingid(matchingid='12345')
		study_subject = create_study_subject( 
			:identifier_attributes => Factory.attributes_for(:identifier,
				{ :matchingid => matchingid })).reload
	end

	def create_case_study_subject_for_duplicate_search(options={})
		Factory(:case_study_subject, { :sex => 'M',
			:pii_attributes => Factory.attributes_for(:pii,
				:dob => Date.yesterday),
#	we no longer need the identifier in the check since hospital_no moved
#			:identifier_attributes => Factory.attributes_for(:identifier),
			:patient_attributes => Factory.attributes_for(:patient,
				:hospital_no => 'matchthis',
				:admit_date => Date.yesterday ) }.deep_merge(options) )
	end

	def new_case_study_subject_for_duplicate_search(options={})
		Factory.build(:case_study_subject, { :sex => 'F',
			:pii_attributes => Factory.attributes_for(:pii,
				:dob => Date.today),
#	we no longer need the identifier in the check since hospital_no moved
#			:identifier_attributes => Factory.attributes_for(:identifier),
			:patient_attributes => Factory.attributes_for(:patient,
				:hospital_no => 'somethingdifferent',
#				:organization_id => 0,	#	Why 0? was for just matching admit_date
				:admit_date => Date.today ) }.deep_merge(options) )
	end

	#	Used more than once so ...
	def create_case_study_subject_with_patient_and_identifier
		study_subject = create_case_study_subject( 
			:patient_attributes    => Factory.attributes_for(:patient,
				{ :admit_date => Chronic.parse('yesterday') }),
			:identifier_attributes => Factory.attributes_for(:identifier,
				{ :matchingid => '12345' })).reload
		assert_not_nil study_subject.reference_date
		assert_not_nil study_subject.patient.admit_date
		assert_equal study_subject.reference_date, study_subject.patient.admit_date
		study_subject
	end

end
