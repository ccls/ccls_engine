require 'test_helper'

class Ccls::SubjectTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_many( :abstracts, :addressings, :enrollments,
		:gift_cards, :phone_numbers, :samples, :interviews )
	assert_should_initially_belong_to( :subject_type, :vital_status )
	assert_should_have_one( :home_exposure_response, :homex_outcome,
		:identifier, :pii )
	assert_should_habtm(:analyses)
	assert_requires_complete_date( :reference_date )
	assert_should_require_attributes_not_nil( :do_not_contact )
	assert_should_not_require_attributes( :vital_status_id, :hispanicity_id, 
		:reference_date, :response_sets_count, :sex )

	test "create_control_subject should not create a subject type" do
		assert_difference( 'SubjectType.count', 0 ){
		assert_difference( "Subject.count", 1 ) {
			subject = create_control_subject
			assert !subject.is_case?
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "create_case_subject should not create a subject type" do
		assert_difference( 'SubjectType.count', 0 ){
		assert_difference( "Subject.count", 1 ) {
			subject = create_case_subject
			assert subject.is_case?
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should create subject" do
		assert_difference( 'VitalStatus.count', 1 ){
		assert_difference( 'SubjectType.count', 1 ){
		assert_difference( "Subject.count", 1 ) {
			subject = create_subject
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} } }
	end

	test "should create subject with language" do
		assert_difference( 'Language.count', 1 ){
		assert_difference( 'SubjectLanguage.count', 1 ){
		assert_difference( "Subject.count", 1 ) {
			subject = create_subject
			subject.languages << Factory(:language)
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} } }
	end

	test "should create subject and accept_nested_attributes_for addressings" do
		assert_difference( 'Address.count', 1) {
		assert_difference( 'Addressing.count', 1) {
		assert_difference( "Subject.count", 1 ) {
			subject = create_subject(
				:addressings_attributes => [Factory.attributes_for(:addressing,
					:address_attributes => Factory.attributes_for(:address,
					:address_type => AddressType['residence'] ) )])
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} } }
	end

	test "should create subject and ignore blank address" do
		assert_difference( 'Address.count', 0) {
		assert_difference( 'Addressing.count', 0) {
		assert_difference( "Subject.count", 1 ) {
			subject = create_subject(
				:addressings_attributes => [Factory.attributes_for(:addressing,
					:address_attributes => { :address_type => AddressType['residence'] } )])
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} } }
	end

	test "should respond to residence_addresses_count" do
		subject = create_subject
		assert subject.respond_to?(:residence_addresses_count)
		assert_equal 0, subject.residence_addresses_count
		subject.update_attributes(
				:addressings_attributes => [Factory.attributes_for(:addressing,
					:address_attributes => Factory.attributes_for(:address,
					{ :address_type => AddressType['residence'] } ))])
		assert_equal 1, subject.reload.residence_addresses_count
		subject.update_attributes(
				:addressings_attributes => [Factory.attributes_for(:addressing,
					:address_attributes => Factory.attributes_for(:address,
					{ :address_type => AddressType['residence'] } ))])
		assert_equal 2, subject.reload.residence_addresses_count
	end

	test "should create subject and accept_nested_attributes_for phone_numbers" do
		assert_difference( 'PhoneNumber.count', 1) {
		assert_difference( "Subject.count", 1 ) {
			subject = create_subject(
				:phone_numbers_attributes => [Factory.attributes_for(:phone_number)])
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should create subject and ignore blank phone_number" do
		assert_difference( 'PhoneNumber.count', 0) {
		assert_difference( "Subject.count", 1 ) {
			subject = create_subject(
				:phone_numbers_attributes => [Factory.attributes_for(:phone_number,
					:phone_number => '' )])
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should create subject and accept_nested_attributes_for enrollments" do
		assert_difference( 'Enrollment.count', 1) {
		assert_difference( "Subject.count", 1 ) {
			subject = create_subject(
				:enrollments_attributes => [Factory.attributes_for(:enrollment,
					:project_id => Project['non-specific'].id)])
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should create subject and accept_nested_attributes_for pii" do
		assert_difference( 'Pii.count', 1) {
		assert_difference( "Subject.count", 1 ) {
			subject = create_subject(
				:pii_attributes => Factory.attributes_for(:pii))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create subject with second pii" do
		assert_difference( 'Pii.count', 1) {
		assert_difference( "Subject.count", 1 ) {
			subject = create_subject(
				:pii_attributes => Factory.attributes_for(:pii))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
			subject.reload.update_attributes(
				:pii_attributes => Factory.attributes_for(:pii))
#	with :touch enabled, this will create a new pii and
#	nullify the previous pii's study_subject_id
#	don't quite understand it, but it does
			assert subject.pii.errors.on_attr_and_type('study_subject_id',:taken)
			assert subject.errors.on_attr_and_type('pii.study_subject_id',:taken)
		} }
	end

	test "should NOT create subject with empty pii" do
		assert_difference( 'Pii.count', 0) {
		assert_difference( "Subject.count", 0 ) {
			subject = create_subject( :pii_attributes => {})
#			assert subject.errors.on('pii.state_id_no')
			assert subject.errors.on_attr_and_type('pii.dob',:blank)
		} }
	end



	test "should create subject and accept_nested_attributes_for homex_outcome" do
		assert_difference( 'HomexOutcome.count', 1) {
		assert_difference( "Subject.count", 1 ) {
			subject = create_subject(
				:homex_outcome_attributes => Factory.attributes_for(:homex_outcome))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create subject with second homex_outcome" do
		assert_difference( 'HomexOutcome.count', 1) {
		assert_difference( "Subject.count", 1 ) {
			subject = create_subject(
				:homex_outcome_attributes => Factory.attributes_for(:homex_outcome))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
			subject.reload.update_attributes(
				:homex_outcome_attributes => Factory.attributes_for(:homex_outcome))
			assert subject.errors.on_attr_and_type('homex_outcome.study_subject_id',:taken)
		} }
	end

	test "should NOT create subject with empty homex_outcome" do
pending
#		assert_difference( 'HomexOutcome.count', 0) {
#		assert_difference( 'Subject.count', 0) {
#			subject = create_subject( :homex_outcome_attributes => {})
##			assert subject.errors.on('homex_outcome.state_id_no')	
#			puts subject.errors.inspect
#		} }
	end

	test "should create case subject and accept_nested_attributes_for patient" do
		assert_difference( 'Patient.count', 1) {
		assert_difference( "Subject.count", 1 ) {
			subject = Factory(:case_subject,
				:patient_attributes => Factory.attributes_for(:patient))
			assert  subject.is_case?
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create non-case subject with patient" do
		assert_difference( 'Patient.count', 0) {
		assert_difference( "Subject.count", 0 ) {
			subject = create_subject(
				:patient_attributes => Factory.attributes_for(:patient))
			assert !subject.is_case?
			assert subject.errors.on(:patient)	#	no type
			assert  subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should create patient for case subject" do
		assert_difference( 'Patient.count', 1) {
		assert_difference( "Subject.count", 1 ) {
			subject = Factory(:case_subject)
			assert subject.is_case?
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
			patient = Factory(:patient, :subject => subject)
			assert !patient.new_record?, 
				"#{patient.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create patient for non-case subject" do
		assert_difference( 'Patient.count', 0) {
		assert_difference( "Subject.count", 1 ) {
			subject = create_subject
			assert !subject.is_case?
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
			patient = Factory.build(:patient, :subject => subject)
			patient.save	#	avoid an exception being raised
			assert patient.errors.on(:subject)
		} }
	end

	test "should NOT create subject with second patient" do
		#	this should be failing, but I don't think that I can stop it 
		#	when using accepts_nested_attributes_for
		assert_difference( 'Patient.count', 1) {
		assert_difference( "Subject.count", 1 ) {
			subject = Factory(:case_subject,
				:patient_attributes => Factory.attributes_for(:patient))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
			subject.reload.update_attributes(
				:patient_attributes => Factory.attributes_for(:patient))
			assert subject.errors.on_attr_and_type('patient.study_subject_id',:taken)
		} }
	end

	test "should NOT create subject with empty patient" do
pending
		assert_difference( 'Patient.count', 0) {
		assert_difference( "Subject.count", 0 ) {
#			subject = create_subject( :pii_attributes => {})
#			assert subject.errors.on('patient.state_id_no')
#	##	patient has no requirements so it would actually work
#	##	TODO
		} }
	end



	test "should create subject and accept_nested_attributes_for identifier" do
		assert_difference( 'Identifier.count', 1) {
		assert_difference( 'Subject.count', 1) {
			subject = create_subject(
				:identifier_attributes => Factory.attributes_for(:identifier))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create subject with second identifier" do
		assert_difference( 'Identifier.count', 1) {
		assert_difference( "Subject.count", 1 ) {
			subject = create_subject(
				:identifier_attributes => Factory.attributes_for(:identifier))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
			subject.reload.update_attributes(
				:identifier_attributes => Factory.attributes_for(:identifier))
			assert subject.identifier.errors.on_attr_and_type('study_subject_id',:taken)
			assert subject.errors.on_attr_and_type('identifier.study_subject_id',:taken)
		} }
	end

	test "should NOT create subject with empty identifier" do
		assert_difference( 'Identifier.count', 0) {
		assert_difference( 'Subject.count', 0) {
			subject = create_subject( :identifier_attributes => {} )
#			assert subject.errors.on_attr_and_type('identifier.orderno',:blank)
#			assert subject.errors.on_attr_and_type('identifier.patid',:blank)
			assert subject.errors.on_attr_and_type('identifier.case_control_type',:blank)
#			assert subject.errors.on_attr_and_type('identifier.childid',:blank)
		} }
	end

	test "studyid should be patid, case_control_type and orderno" do
		Identifier.any_instance.stubs(:get_next_patid).returns('123')
		subject = create_subject(
			:identifier_attributes => Factory.attributes_for(:identifier, 
				:case_control_type => 'c'
		)).reload
		Identifier.any_instance.unstub(:get_next_patid)
		assert_equal "0123-C-0", subject.studyid
		assert_equal "0123C0",   subject.identifier.studyid_nohyphen
		assert_equal "012300",   subject.identifier.studyid_intonly_nohyphen
	end

	test "should belong to vital_status" do
		subject = create_subject(:vital_status => nil)
		assert_nil subject.vital_status
		subject.vital_status = Factory(:vital_status)
		assert_not_nil subject.vital_status
	end

	test "should belong to hispanicity" do
		subject = create_subject
pending
#		assert_nil subject.vital_status
#		subject.vital_status = Factory(:vital_status)
#		assert_not_nil subject.vital_status
	end

#	test "should NOT destroy dust_kit with subject" do
#		subject = create_subject
#		Factory(:dust_kit, :subject => subject)
#		assert_difference('Subject.count',-1) {
#		assert_difference('DustKit.count',0) {
#			subject.destroy
#		} }
#	end

	test "should NOT destroy identifier with subject" do
		subject = create_subject
		Factory(:identifier, :subject => subject)
		assert_difference( "Subject.count", -1 ) {
		assert_difference('Identifier.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy pii with subject" do
		subject = create_subject
		Factory(:pii, :subject => subject)
		assert_difference( "Subject.count", -1 ) {
		assert_difference('Pii.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy patient with subject" do
		subject = Factory(:case_subject)
		Factory(:patient, :subject => subject)
		assert_difference( "Subject.count", -1 ) {
		assert_difference('Patient.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy home_exposure_response with subject" do
		subject = Factory(:home_exposure_response).subject
		assert_difference( "Subject.count", -1 ) {
		assert_difference('HomeExposureResponse.count',0) {
			subject.destroy
		} }
	end

#	test "should NOT destroy addresses with subject" do
#		subject = create_subject
#		Factory(:address, :subject => subject)
#		Factory(:address, :subject => subject)
#		assert_difference('Subject.count',-1) {
#		assert_difference('Address.count',0) {
#			subject.destroy
#		} }
#	end

#	test "should NOT destroy operational_events with subject" do
#		subject = create_subject
#		Factory(:operational_event, :subject => subject)
#		Factory(:operational_event, :subject => subject)
#		assert_difference('Subject.count',-1) {
#		assert_difference('OperationalEvent.count',0) {
#			subject.destroy
#		} }
#	end

	test "should NOT destroy enrollments with subject" do
		subject = create_subject
		Factory(:enrollment, :subject => subject)
		Factory(:enrollment, :subject => subject)
		assert_difference( "Subject.count", -1 ) {
		assert_difference('Enrollment.count',0) {
			subject.destroy
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

	test "should NOT destroy samples with subject" do
		subject = create_subject
		Factory(:sample, :subject => subject)
		Factory(:sample, :subject => subject)
		assert_difference( "Subject.count", -1 ) {
		assert_difference('Sample.count',0) {
			subject.destroy
		} }
	end

	%w( full_name first_name last_name fathers_name 
			mothers_name mother_maiden_name email dob state_id_no
			ssn childid patid orderno studyid 
			interview_outcome interview_outcome_on 
			sample_outcome sample_outcome_on ).each do |method_name|

		test "should respond to #{method_name}" do
			subject = create_subject
			assert subject.respond_to?(method_name)
		end

	end

#	%w( ssn childid patid orderno studyid state_id_no ).each do |method_name|
#	patid will be nil for non-case until assigned
#	%w( ssn patid orderno studyid state_id_no ).each do |method_name|
#	orderno is generated
#	%w( ssn childid orderno studyid state_id_no ).each do |method_name|
	%w( ssn childid studyid state_id_no ).each do |method_name|

		test "should return nil #{method_name} without identifier" do
			subject = create_subject
			assert_nil subject.send(method_name)
		end

		test "should return #{method_name} with identifier" do
#			subject = create_subject(:identifier => Factory(:identifier))
			subject = create_subject(:identifier_attributes => Factory.attributes_for(:identifier))
			assert_not_nil subject.send(method_name)
		end

	end

	%w( full_name first_name last_name fathers_name 
			mothers_name email dob ).each do |method_name|

		test "should return nil #{method_name} without pii" do
			subject = create_subject
			assert_nil subject.send(method_name)
		end

		test "should return #{method_name} with pii" do
#			subject = Factory(:pii, :subject => create_subject).subject
			subject = create_subject(:pii_attributes => Factory.attributes_for(:pii))
			assert_not_nil subject.send(method_name)
		end

	end

	%w( interview_outcome interview_outcome_on 
			sample_outcome sample_outcome_on ).each do |method_name|

		test "should return nil #{method_name} without homex_outcome" do
			subject = create_subject
			assert_nil subject.send(method_name)
		end

		test "should return #{method_name} with homex_outcome" do
#			subject = Factory(:homex_outcome, :subject => create_subject).subject
			subject = create_subject(:homex_outcome_attributes => Factory.attributes_for(:homex_outcome))
#			assert_not_nil subject.send(method_name)
		end

	end

	test "should be ineligible for invitation without email" do
		subject = create_subject
		assert !subject.is_eligible_for_invitation?
	end

	test "should be eligible for invitation with email" do
		subject = create_subject(
			:pii_attributes => Factory.attributes_for(:pii))
		assert subject.is_eligible_for_invitation?
	end


#	test "should destroy patient on subject destroy" do
#		assert_difference( 'Patient.count', 1) {
#		assert_difference( 'Subject.count', 1) {
#			@subject = create_subject(
#				:patient_attributes => Factory.attributes_for(:patient))
#		} }
#		assert_difference( 'Patient.count', -1) {
#		assert_difference( 'Subject.count', -1) {
#			@subject.destroy
#		} }
#	end
#
#	test "should destroy dust_kit on subject destroy" do
#		assert_difference( 'DustKit.count', 1) {
#		assert_difference( 'Subject.count', 1) {
#			@subject = create_subject(
#				:dust_kit_attributes => Factory.attributes_for(:dust_kit))
#		} }
#		assert_difference( 'DustKit.count', -1) {
#		assert_difference( 'Subject.count', -1) {
#			@subject.destroy
#		} }
#	end
#
#	test "should destroy identifier on subject destroy" do
#		assert_difference( 'Identifier.count', 1) {
#		assert_difference( 'Subject.count', 1) {
#			@subject = create_subject(
#				:identifier_attributes => Factory.attributes_for(:identifier))
#		} }
#		assert_difference( 'Identifier.count', -1) {
#		assert_difference( 'Subject.count', -1) {
#			@subject.destroy
#		} }
#	end
#
#	test "should destroy pii on subject destroy" do
#		assert_difference( 'Pii.count', 1) {
#		assert_difference( 'Subject.count', 1) {
#			@subject = create_subject(
#				:pii_attributes => Factory.attributes_for(:pii))
#		} }
#		assert_difference( 'Pii.count', -1) {
#		assert_difference( 'Subject.count', -1) {
#			@subject.destroy
#		} }
#	end

	test "should return race name for string" do
		subject = create_subject
		assert_equal subject.race_names, 
			"#{subject.races.first}"
	end

	test "should return subject_type description for string" do
		subject = create_subject
		assert_equal subject.subject_type.description,
			"#{subject.subject_type}"
	end

	test "should return nil hx_enrollment if not enrolled" do
		subject = create_subject
		assert_nil subject.hx_enrollment
	end

	test "should return valid hx_enrollment if enrolled" do
		subject = create_subject
		hx_enrollment = Factory(:enrollment,
			:subject => subject,
			:project => Project['HomeExposures']
		)
		assert_not_nil subject.hx_enrollment
	end

	test "should not be case unless explicitly told" do
		subject = create_subject
		assert !subject.is_case?
	end

	test "should case if explicitly told" do
		subject = Factory(:case_subject)
		assert subject.is_case?
	end

	test "should not have hx_interview" do
		subject = create_subject
		assert_nil subject.hx_interview
	end

	test "should have hx_interview" do
		subject = create_hx_interview_subject
		assert_not_nil subject.hx_interview
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
		assert_equal Subject.hx_id, hx_id
	end

	test "should search for_hx" do
		subjects = Subject.for_hx()
		assert_not_nil subjects
		assert subjects.is_a?(Array)
	end

	test "should search for_hx_interview" do
		subjects = Subject.for_hx_interview()
		assert_not_nil subjects
		assert subjects.is_a?(Array)
	end

	test "should search need_gift_card" do
		subjects = Subject.need_gift_card()
		assert_not_nil subjects
		assert subjects.is_a?(Array)
	end

	test "should search for_hx_followup" do
		subjects = Subject.for_hx_followup()
		assert_not_nil subjects
		assert subjects.is_a?(Array)
	end

	test "should search for_hx_sample" do
		subjects = Subject.for_hx_sample()
		assert_not_nil subjects
		assert subjects.is_a?(Array)
	end

	test "should create subject with empty subject_languages_attributes" do
		assert_difference( 'SubjectLanguage.count', 0 ){
		assert_difference( "Subject.count", 1 ) {
			@subject = create_subject(:subject_languages_attributes => { })
			assert !@subject.new_record?, 
				"#{@subject.errors.full_messages.to_sentence}"
		} }
		assert @subject.languages.empty?
		assert @subject.subject_languages.empty?
	end

	test "should create subject with blank language_id" do
		assert_difference( 'SubjectLanguage.count', 0 ){
		assert_difference( "Subject.count", 1 ) {
			@subject = create_subject(:subject_languages_attributes => { 
				:some_random_id => { :language_id => '' }
			})
			assert !@subject.new_record?, 
				"#{@subject.errors.full_messages.to_sentence}"
		} }
		assert @subject.languages.empty?
		assert @subject.subject_languages.empty?
	end

	test "should create subject with subject_languages_attributes language_id" do
		assert Language.count > 0
		assert_difference( 'SubjectLanguage.count', 1 ){
		assert_difference( "Subject.count", 1 ) {
			@subject = create_subject(:subject_languages_attributes => {
				:some_random_id => { :language_id => Language.first.id }
			})
			assert !@subject.new_record?, 
				"#{@subject.errors.full_messages.to_sentence}"
		} }
		assert !@subject.languages.empty?
		assert_equal 1, @subject.languages.length
		assert !@subject.subject_languages.empty?
		assert_equal 1, @subject.subject_languages.length
	end

	test "should create subject with subject_languages_attributes multiple languages" do
		assert Language.count > 1
		languages = Language.all
		assert_difference( 'SubjectLanguage.count', 2 ){
		assert_difference( "Subject.count", 1 ) {
			@subject = create_subject(:subject_languages_attributes => {
				:some_random_id1 => { :language_id => languages[0].id },
				:some_random_id2 => { :language_id => languages[1].id }
			})
			assert !@subject.new_record?, 
				"#{@subject.errors.full_messages.to_sentence}"
		} }
		assert !@subject.languages.empty?
		assert_equal 2, @subject.languages.length
		assert !@subject.subject_languages.empty?
		assert_equal 2, @subject.subject_languages.length
	end

	test "should NOT create subject with subject_languages_attributes " <<
			"if language is other and no other given" do
		assert Language.count > 0
		assert_difference( 'SubjectLanguage.count', 0 ){
		assert_difference( "Subject.count", 0 ) {
			@subject = create_subject(:subject_languages_attributes => {
				:some_random_id => { :language_id => Language['other'].id }
			})
			assert @subject.errors.on_attr_and_type("subject_languages.other",:blank)
		} }
	end


	test "should create subject with empty subject_races_attributes" do
		assert_difference( 'SubjectRace.count', 0 ){
		assert_difference( "Subject.count", 1 ) {
			@subject = create_subject(:subject_races_attributes => { })
			assert !@subject.new_record?, 
				"#{@subject.errors.full_messages.to_sentence}"
		} }
		assert @subject.races.empty?
		assert @subject.subject_races.empty?
	end

	test "should create subject with blank race_id" do
		assert_difference( 'SubjectRace.count', 0 ){
		assert_difference( "Subject.count", 1 ) {
			@subject = create_subject(:subject_races_attributes => { 
				:some_random_id => { :race_id => '' }
			})
			assert !@subject.new_record?, 
				"#{@subject.errors.full_messages.to_sentence}"
		} }
		assert @subject.races.empty?
		assert @subject.subject_races.empty?
	end

	test "should create subject with subject_races_attributes race_id" do
		assert Race.count > 0
		assert_difference( 'SubjectRace.count', 1 ){
		assert_difference( "Subject.count", 1 ) {
			@subject = create_subject(:subject_races_attributes => {
				:some_random_id => { :race_id => Race.first.id }
			})
			assert !@subject.new_record?, 
				"#{@subject.errors.full_messages.to_sentence}"
		} }
		assert !@subject.races.empty?
		assert !@subject.subject_races.empty?
		assert !@subject.subject_races.first.is_primary
	end

	test "should create subject with subject_races_attributes race_id and is_primary" do
		assert Race.count > 0
		assert_difference( 'SubjectRace.count', 1 ){
		assert_difference( "Subject.count", 1 ) {
			@subject = create_subject(:subject_races_attributes => {
				:some_random_id => { :race_id => Race.first.id, :is_primary => 'true' }
			})
			assert !@subject.new_record?, 
				"#{@subject.errors.full_messages.to_sentence}"
		} }
		assert !@subject.races.empty?
		assert !@subject.subject_races.empty?
		assert  @subject.subject_races.first.is_primary
	end

	test "should create subject with subject_races_attributes multiple races" do
		assert Race.count > 2
		races = Race.all
		assert_difference( 'SubjectRace.count', 3 ){
		assert_difference( "Subject.count", 1 ) {
			@subject = create_subject(:subject_races_attributes => {
				:some_random_id1 => { :race_id => races[1].id },
				:some_random_id2 => { :race_id => races[2].id },
				:some_random_id3 => { :race_id => races[3].id }
			})
			assert !@subject.new_record?, 
				"#{@subject.errors.full_messages.to_sentence}"
		} }
		assert !@subject.races.empty?
		assert_equal 3, @subject.races.length
		assert !@subject.subject_races.empty?
		assert_equal 3, @subject.subject_races.length
		assert !@subject.subject_races.collect(&:is_primary).any?
	end

	test "should create subject with subject_races_attributes multiple races and is_primaries" do
		assert Race.count > 2
		races = Race.all
		assert_difference( 'SubjectRace.count', 3 ){
		assert_difference( "Subject.count", 1 ) {
			@subject = create_subject(:subject_races_attributes => {
				:some_random_id1 => { :race_id => races[1].id, :is_primary => 'true' },
				:some_random_id2 => { :race_id => races[2].id, :is_primary => 'true' },
				:some_random_id3 => { :race_id => races[3].id, :is_primary => 'true' }
			})
			assert !@subject.new_record?, 
				"#{@subject.errors.full_messages.to_sentence}"
		} }
		assert !@subject.races.empty?
		assert_equal 3, @subject.races.length
		assert !@subject.subject_races.empty?
		assert_equal 3, @subject.subject_races.length
		assert  @subject.subject_races.collect(&:is_primary).all?
	end

	test "should create subject with subject_races_attributes with is_primary and no race_id" do
		assert Race.count > 0
		assert_difference( 'SubjectRace.count', 0 ){
		assert_difference( "Subject.count", 1 ) {
			@subject = create_subject(:subject_races_attributes => {
				:some_random_id => { :is_primary => 'true' }
			})
			assert !@subject.new_record?, 
				"#{@subject.errors.full_messages.to_sentence}"
		} }
		assert @subject.races.empty?
		assert @subject.subject_races.empty?
	end

	test "should update subject with subject_races_attributes" do
		assert Race.count > 0
		assert_difference( 'SubjectRace.count', 0 ){
		assert_difference( "Subject.count", 1 ) {
			@subject = create_subject
			assert !@subject.new_record?, 
				"#{@subject.errors.full_messages.to_sentence}"
		} }
		assert @subject.races.empty?
		assert @subject.subject_races.empty?
		assert_difference( 'SubjectRace.count', 1 ){
		assert_difference( "Subject.count", 0 ) {
			@subject.update_attributes(:subject_races_attributes => {
				:some_random_id => { :race_id => Race.first.id, :is_primary => 'true' }
			})
		} }
		assert !@subject.races.empty?
		assert !@subject.subject_races.empty?
		assert  @subject.subject_races.first.is_primary
	end

	test "should raise Subject::NotTwoAbstracts with 0 abstracts on abstracts_the_same?" do
		subject = Factory(:subject)
		assert_equal 0, subject.abstracts.length
		assert_raise(Subject::NotTwoAbstracts) {
			subject.abstracts_the_same?
		}
	end

	test "should raise Subject::NotTwoAbstracts with 1 abstracts on abstracts_the_same?" do
		subject = Factory(:subject)
		Factory(:abstract, :subject => subject)
		subject.reload
		assert_equal 1, subject.abstracts.length
		assert_raise(Subject::NotTwoAbstracts) {
			subject.abstracts_the_same?
		}
	end

	test "should return true if abstracts are the same on abstracts_the_same?" do
		subject = Factory(:subject)
		Factory(:abstract, :subject => subject)
		Factory(:abstract, :subject => subject)
		subject.reload
		assert_equal 2, subject.abstracts.length
		assert subject.abstracts_the_same?
	end

	test "should raise Subject::NotTwoAbstracts with 3 abstracts on abstracts_the_same?" do
		subject = Factory(:subject)
		Factory(:abstract, :subject => subject)
		Factory(:abstract, :subject => subject)
		Factory(:abstract, :subject => subject)
		subject.reload
		assert_equal 3, subject.abstracts.length
		assert_raise(Subject::NotTwoAbstracts) {
			subject.abstracts_the_same?
		}
	end

	test "should raise Subject::NotTwoAbstracts with 0 abstracts on abstract_diffs" do
		subject = Factory(:subject)
		assert_equal 0, subject.abstracts.length
		assert_raise(Subject::NotTwoAbstracts) {
			subject.abstract_diffs
		}
	end

	test "should raise Subject::NotTwoAbstracts with 1 abstracts on abstract_diffs" do
		subject = Factory(:subject)
		Factory(:abstract, :subject => subject)
		subject.reload
		assert_equal 1, subject.abstracts.length
		assert_raise(Subject::NotTwoAbstracts) {
			subject.abstract_diffs
		}
	end

	test "should return true if abstracts are the same on abstract_diffs" do
		subject = Factory(:subject)
		Factory(:abstract, :subject => subject)
		Factory(:abstract, :subject => subject)
		subject.reload
		assert_equal 2, subject.abstracts.length
		assert_equal Hash.new, subject.abstract_diffs
		assert       subject.abstract_diffs.empty?
	end

	test "should raise Subject::NotTwoAbstracts with 3 abstracts on abstract_diffs" do
		subject = Factory(:subject)
		Factory(:abstract, :subject => subject)
		Factory(:abstract, :subject => subject)
		Factory(:abstract, :subject => subject)
		subject.reload
		assert_equal 3, subject.abstracts.length
		assert_raise(Subject::NotTwoAbstracts) {
			subject.abstract_diffs
		}
	end


	test "should set subject.reference_date to self.patient.admit_date on create" do
		create_case_subject_with_patient_and_identifier
	end

	test "should update all matching subjects' reference date " <<
			"with updated admit date" do
		subject = create_case_subject(
			:patient_attributes    => Factory.attributes_for(:patient),
			:identifier_attributes => Factory.attributes_for(:identifier,
				{ :matchingid => '12345' })).reload
		other   = create_subject_with_matchingid
		nobody  = create_subject_with_matchingid('54321')
		assert_nil subject.reference_date
		assert_nil subject.patient.admit_date
		assert_nil other.reference_date
		assert_nil nobody.reference_date
		subject.patient.update_attributes(
			:admit_date => Chronic.parse('yesterday'))
		assert_not_nil subject.patient.admit_date
		assert_not_nil subject.reload.reference_date
		assert_not_nil other.reload.reference_date
		assert_nil     nobody.reload.reference_date
		assert_equal subject.reference_date, subject.patient.admit_date
		assert_equal subject.reference_date, other.reference_date
	end

	test "should set subject.reference_date to matching patient.admit_date " <<
			"on create with patient created first" do
		subject = create_case_subject_with_patient_and_identifier
		other   = create_subject_with_matchingid
		assert_not_nil other.reference_date
		assert_equal   other.reference_date, subject.reference_date
		assert_equal   other.reference_date, subject.patient.admit_date
	end

	test "should set subject.reference_date to matching patient.admit_date " <<
			"on create with patient created last" do
		other   = create_subject_with_matchingid
		subject = create_case_subject_with_patient_and_identifier
		assert_not_nil other.reload.reference_date
		assert_equal   other.reference_date, subject.reference_date
		assert_equal   other.reference_date, subject.patient.admit_date
	end

	test "should nullify subject.reference_date if matching patient changes matchingid" do
		other   = create_subject_with_matchingid
		subject = create_case_subject_with_patient_and_identifier
		assert_not_nil other.reload.reference_date
		subject.identifier.update_attributes(:matchingid => '12346')
		assert_nil     other.reload.reference_date
	end

	test "should nullify subject.reference_date if matching patient nullifies matchingid" do
		other   = create_subject_with_matchingid
		subject = create_case_subject_with_patient_and_identifier
		assert_not_nil other.reload.reference_date
		subject.identifier.update_attributes(:matchingid => nil)
		assert_nil     other.reload.reference_date
	end

	test "should nullify subject.reference_date if matching patient nullifies admit_date" do
		other   = create_subject_with_matchingid
		subject = create_case_subject_with_patient_and_identifier
		assert_not_nil other.reload.reference_date
		subject.patient.update_attributes(:admit_date => nil)
		assert_nil     other.reload.reference_date
	end

	test "should create_home_exposure_with_subject" do
		subject = create_home_exposure_with_subject
		assert subject.is_a?(Subject)
	end

	test "should create_home_exposure_with_subject with patient" do
		subject = create_home_exposure_with_subject(:patient => true)
		assert subject.is_a?(Subject)
	end

protected

	def create_subject_with_matchingid(matchingid='12345')
		subject = create_subject( 
			:identifier_attributes => Factory.attributes_for(:identifier,
				{ :matchingid => matchingid })).reload
	end

	#	Used more than once so ...
	def create_case_subject_with_patient_and_identifier
		subject = create_case_subject( 
			:patient_attributes    => Factory.attributes_for(:patient,
				{ :admit_date => Chronic.parse('yesterday') }),
			:identifier_attributes => Factory.attributes_for(:identifier,
				{ :matchingid => '12345' })).reload
		assert_not_nil subject.reference_date
		assert_not_nil subject.patient.admit_date
		assert_equal subject.reference_date, subject.patient.admit_date
		subject
	end

#	def create_dust_kit(options = {})
#		Factory(:dust_kit, {
#			:kit_package_attributes  => Factory.attributes_for(:package),
#			:dust_package_attributes => Factory.attributes_for(:package) 
#		}.merge(options))
#	end

end
