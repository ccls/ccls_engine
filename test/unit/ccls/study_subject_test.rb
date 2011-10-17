require 'test_helper'

class Ccls::StudySubjectTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_many( :abstracts, :addressings, :enrollments,
		:gift_cards, :phone_numbers, :samples, :interviews, :bc_requests )
	assert_should_initially_belong_to( :subject_type, :vital_status )
	assert_should_have_one( :home_exposure_response, :homex_outcome,
		:identifier, :pii )
	assert_should_habtm(:analyses)
	assert_requires_complete_date( :reference_date )
	assert_should_require_attributes_not_nil( :do_not_contact )
	assert_should_not_require_attributes( :vital_status_id, :hispanicity_id, 
		:reference_date, :sex,
		:mother_yrs_educ, :father_yrs_educ, :birth_type, :birth_county, :is_duplicate_of )

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
				:phone_numbers_attributes => [Factory.attributes_for(:phone_number)])
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
		assert_difference( 'Enrollment.count', 1) {
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
#			assert study_subject.errors.on('pii.state_id_no')
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
#		assert_difference( 'HomexOutcome.count', 0) {
#		assert_difference( 'StudySubject.count', 0) {
#			study_subject = create_study_subject( :homex_outcome_attributes => {})
##			assert study_subject.errors.on('homex_outcome.state_id_no')	
#			puts study_subject.errors.inspect
#		} }
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
pending
		assert_difference( 'Patient.count', 0) {
		assert_difference( "StudySubject.count", 0 ) {
#			study_subject = create_study_subject( :pii_attributes => {})
#			assert study_subject.errors.on('patient.state_id_no')
#	##	patient has no requirements so it would actually work
#	##	TODO
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
#		test "should NOT create study_subject with empty identifier" do
#			assert_difference( 'Identifier.count', 0) {
#			assert_difference( 'StudySubject.count', 0) {
#				study_subject = create_study_subject( :identifier_attributes => {} )
#	#			assert study_subject.errors.on_attr_and_type('identifier.orderno',:blank)
#	#			assert study_subject.errors.on_attr_and_type('identifier.patid',:blank)
#				assert study_subject.errors.on_attr_and_type('identifier.case_control_type',:blank)
#	#			assert study_subject.errors.on_attr_and_type('identifier.childid',:blank)
#			} }
#		end

	test "studyid should be patid, case_control_type and orderno" do
		Identifier.any_instance.stubs(:get_next_patid).returns('123')
#		study_subject = create_study_subject(
#			:identifier_attributes => Factory.attributes_for(:identifier, 
#				:case_control_type => 'c'
#		)).reload
		study_subject = Factory(:case_identifier).reload.study_subject
		Identifier.any_instance.unstub(:get_next_patid)
		assert_equal "0123-C-0", study_subject.studyid
		assert_equal "0123C0",   study_subject.identifier.studyid_nohyphen
		assert_equal "012300",   study_subject.identifier.studyid_intonly_nohyphen
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

#	test "should NOT destroy addresses with study_subject" do
#		study_subject = create_study_subject
#		Factory(:address, :study_subject => study_subject)
#		Factory(:address, :study_subject => study_subject)
#		assert_difference('StudySubject.count',-1) {
#		assert_difference('Address.count',0) {
#			study_subject.destroy
#		} }
#	end

#	test "should NOT destroy operational_events with study_subject" do
#		study_subject = create_study_subject
#		Factory(:operational_event, :study_subject => study_subject)
#		Factory(:operational_event, :study_subject => study_subject)
#		assert_difference('StudySubject.count',-1) {
#		assert_difference('OperationalEvent.count',0) {
#			study_subject.destroy
#		} }
#	end

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
		object = create_object
		assert_equal 0, object.analyses.length
		object.analyses << Factory(:analysis)
		assert_equal 1, object.reload.analyses.length
		object.analyses << Factory(:analysis)
		assert_equal 2, object.reload.analyses.length
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

	%w( initials full_name first_name last_name fathers_name 
			mothers_name mother_maiden_name email dob state_id_no
			local_registrar_no state_registrar_no
			ssn childid patid orderno studyid 
			interview_outcome interview_outcome_on 
			sample_outcome sample_outcome_on ).each do |method_name|

		test "should respond to #{method_name}" do
			study_subject = create_study_subject
			assert study_subject.respond_to?(method_name)
		end

	end

	%w( ssn childid studyid state_id_no ).each do |method_name|

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

	%w( initials full_name first_name last_name fathers_name 
			mothers_name email dob ).each do |method_name|

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

	%w( interview_outcome interview_outcome_on 
			sample_outcome sample_outcome_on ).each do |method_name|

		test "should return nil #{method_name} without homex_outcome" do
			study_subject = create_study_subject
			assert_nil study_subject.send(method_name)
		end

		test "should return #{method_name} with homex_outcome" do
			study_subject = create_study_subject(
				:homex_outcome_attributes => Factory.attributes_for(:homex_outcome))
#			assert_not_nil study_subject.send(method_name)
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
		assert_nil study_subject.hx_enrollment
	end

	test "should return valid hx_enrollment if enrolled" do
		study_subject = create_study_subject
		hx_enrollment = Factory(:enrollment,
			:study_subject => study_subject,
			:project => Project['HomeExposures']
		)
		assert_not_nil study_subject.hx_enrollment
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
		object = create_object
		#	[childid,'(',studyid,full_name,')'].compact.join(' ')
		assert_equal [
			object.childid,'(',object.studyid,object.full_name,')'].compact.join(' '), 
			"#{object}"
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
		assert_nil study_subject.reference_date
		assert_nil study_subject.patient.admit_date
		assert_nil other.reference_date
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

	test "should nullify study_subject.reference_date if matching patient nullifies admit_date" do
		other   = create_study_subject_with_matchingid
		study_subject = create_case_study_subject_with_patient_and_identifier
		assert_not_nil other.reload.reference_date
		study_subject.patient.update_attributes(:admit_date => nil)
		assert_nil     other.reload.reference_date
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
		@study_subject.pii.update_attribute(:dob, nil)
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
		@study_subject.pii.update_attribute(:dob, nil)
		assert_nil @study_subject.reload.dob
	end


	test "should return SOMETHING for next_control_orderno for control" do
		study_subject = create_identifier.study_subject
#		assert_equal 1, case_study_subject.next_control_orderno
pending
	end

	test "should return 1 for next_control_orderno for case with no controls" do
		case_study_subject = create_case_identifier.study_subject
		assert_equal 1, case_study_subject.next_control_orderno
	end

	test "should return 2 for next_control_orderno for case with one control" do
		case_study_subject = create_case_identifier.study_subject
		assert_equal 1, case_study_subject.next_control_orderno
#		control = case_study_subject.create_control({ })
#	add a control
#		assert_equal 2, case_study_subject.next_control_orderno
pending
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
#		assert_difference('Pii.count',1) {
		assert_difference('Identifier.count',1) {
		assert_difference('StudySubject.count',1) {
			@mother = study_subject.create_mother
		} } #}
		assert_equal @mother, study_subject.mother
pending
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
pending
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

	test "should include self in family" do
		study_subject = create_identifier.study_subject.reload
		assert_equal 1, study_subject.family.length
		assert_equal study_subject, study_subject.family.first
	end

	test "should include self in matching" do
		study_subject = create_identifier.study_subject.reload
		assert_equal 1, study_subject.matching.length
		assert_equal study_subject, study_subject.matching.first
	end

	test "should include mother in family" do
		study_subject = create_identifier.study_subject.reload
		mother = study_subject.create_mother
		assert_equal      2, study_subject.family.length
		assert_equal mother, study_subject.family.last
	end

	test "should include father in family" do
		study_subject = create_identifier.study_subject.reload
		father = study_subject.create_father
		assert_equal      2, study_subject.family.length
		assert_equal father, study_subject.family.last
	end

	test "should include mother in matching" do
		study_subject = create_identifier.study_subject.reload
		mother = study_subject.create_mother
		assert_equal      2, study_subject.matching.length
		assert_equal mother, study_subject.matching.last
	end

	test "should include father in matching" do
		study_subject = create_identifier.study_subject.reload
		father = study_subject.create_father
		assert_equal      2, study_subject.matching.length
		assert_equal father, study_subject.matching.last
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

protected

	def create_study_subject_with_matchingid(matchingid='12345')
		study_subject = create_study_subject( 
			:identifier_attributes => Factory.attributes_for(:identifier,
				{ :matchingid => matchingid })).reload
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

#	def create_dust_kit(options = {})
#		Factory(:dust_kit, {
#			:kit_package_attributes  => Factory.attributes_for(:package),
#			:dust_package_attributes => Factory.attributes_for(:package) 
#		}.merge(options))
#	end

end
