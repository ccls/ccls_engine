require File.dirname(__FILE__) + '/../test_helper'

class SubjectTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_many( :addressings )
	assert_should_have_many( :enrollments )
	assert_should_have_many( :gift_cards )
	assert_should_have_many( :phone_numbers )
	assert_should_have_many( :response_sets )
	assert_should_have_many( :samples )
	assert_should_have_many( :survey_invitations )
	assert_should_initially_belong_to( :race )
	assert_should_initially_belong_to( :subject_type )
	assert_should_initially_belong_to( :vital_status )

	assert_should_have_one( :home_exposure_response )
	assert_should_have_one( :homex_outcome )
	assert_should_have_one( :identifier )
	assert_should_have_one( :pii )

	assert_should_habtm(:analyses)

	assert_requires_complete_date( :reference_date )
	assert_should_require_attributes_not_nil( :do_not_contact )
	assert_should_not_require_attributes( :vital_status_id )
	assert_should_not_require_attributes( :hispanicity_id )
	assert_should_not_require_attributes( :reference_date )
	assert_should_not_require_attributes( :response_sets_count )
	assert_should_not_require_attributes( :sex )
	assert_should_not_require_attributes( :matchingid )
	assert_should_not_require_attributes( :familyid )


	test "should create subject" do
		assert_difference( 'Race.count' ){
		assert_difference( 'SubjectType.count' ){
		assert_difference( "#{model_name}.count", 1 ) {
			subject = create_subject
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} } }
	end

	test "should create subject with pii" do
		assert_difference( 'Pii.count', 1) {
		assert_difference( "#{model_name}.count", 1 ) {
			subject = create_subject(
				:pii_attributes => Factory.attributes_for(:pii))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create subject with second pii" do
		assert_difference( 'Pii.count', 1) {
		assert_difference( "#{model_name}.count", 1 ) {
			subject = create_subject(
				:pii_attributes => Factory.attributes_for(:pii))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
			subject.update_attributes(
				:pii_attributes => Factory.attributes_for(:pii))
			assert subject.errors.on('pii.study_subject_id')
		} }
	end

	test "should NOT create subject with empty pii" do
		assert_difference( 'Pii.count', 0) {
		assert_difference( "#{model_name}.count", 0 ) {
			subject = create_subject( :pii_attributes => {})
			assert subject.errors.on('pii.state_id_no')
		} }
	end



	test "should create subject with homex_outcome" do
		assert_difference( 'HomexOutcome.count', 1) {
		assert_difference( "#{model_name}.count", 1 ) {
			subject = create_subject(
				:homex_outcome_attributes => Factory.attributes_for(:homex_outcome))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
		} }
	end

	test "should NOT create subject with second homex_outcome" do
		assert_difference( 'HomexOutcome.count', 1) {
		assert_difference( "#{model_name}.count", 1 ) {
			subject = create_subject(
				:homex_outcome_attributes => Factory.attributes_for(:homex_outcome))
			assert !subject.new_record?, 
				"#{subject.errors.full_messages.to_sentence}"
			subject.update_attributes(
				:homex_outcome_attributes => Factory.attributes_for(:homex_outcome))
			assert subject.errors.on('homex_outcome.study_subject_id')
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

#	test "should create subject with patient" do
#		assert_difference( 'Patient.count', 1) {
#		assert_difference( 'Subject.count', 1) {
##			subject = Factory(:case_subject,
#			subject = create_subject(
#				:patient_attributes => Factory.attributes_for(:patient))
#			assert !subject.new_record?, 
#				"#{subject.errors.full_messages.to_sentence}"
#		} }
#	end

	test "should NOT create subject with second patient" do
		assert_difference( 'Patient.count', 1) {
		assert_difference( "#{model_name}.count", 1 ) {
#			subject = create_subject(
#				:patient_attributes => Factory.attributes_for(:patient))
#			assert !subject.new_record?, 
#				"#{subject.errors.full_messages.to_sentence}"
#			subject.update_attributes(
#				:patient_attributes => Factory.attributes_for(:patient))
#			assert subject.errors.on('patient.study_subject_id')
			subject = Factory(:case_subject)
			patient1 = Factory(:patient,:subject => subject)
			patient2 = Factory.build(:patient,:subject => subject)
			patient2.save
			assert patient2.errors.on(:study_subject_id)
		} }
	end

#	test "should NOT create subject with empty patient" do
#
##	patient has no requirements so it would actually work
##	TODO
#
#		pending
#
#	end

#	test "should create subject with identifier" do
#		assert_difference( 'Identifier.count', 1) {
#		assert_difference( 'Subject.count', 1) {
#			subject = create_subject(
#				:identifier_attributes => Factory.attributes_for(:identifier))
#			assert !subject.new_record?, 
#				"#{subject.errors.full_messages.to_sentence}"
#		} }
#	end

	test "should NOT create subject with second identifier" do
		assert_difference( 'Identifier.count', 1) {
		assert_difference( "#{model_name}.count", 1 ) {
#			subject = create_subject(
#				:identifier_attributes => Factory.attributes_for(:identifier))
#			assert !subject.new_record?, 
#				"#{subject.errors.full_messages.to_sentence}"
#			subject.update_attributes(
#				:identifier_attributes => Factory.attributes_for(:identifier))
			subject = create_subject
			identifier1 = Factory(:identifier,:subject => subject)
			identifier2 = Factory.build(:identifier,:subject => subject)
			identifier2.save
			assert identifier2.errors.on(:study_subject_id)
		} }
	end

#	test "should NOT create subject with empty identifier" do
#		assert_difference( 'Identifier.count', 0) {
#		assert_difference( 'Subject.count', 0) {
#			subject = create_subject(
#				:identifier_attributes => {} )
#			assert subject.errors.on('identifier.childid')
#		} }
#	end

	test "studyid should be patid, case_control_type and orderno" do
#		subject = create_subject(
#			:identifier_attributes => Factory.attributes_for(:identifier, 
#				:case_control_type => 'A',
#				:patid   => '123',
#				:orderno => '4'
#		))
		subject = create_subject
		Factory(:identifier, 
			:subject => subject,
			:case_control_type => 'A',
			:patid   => '123',
			:orderno => '4'
		)
		assert_equal "123-A-4", subject.reload.studyid
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

	def sscount(subject_id,survey_id)
		SurveyInvitation.count(:conditions => {
			:study_subject_id => subject_id, :survey_id => survey_id })
	end

	test "should have one survey_invitation per survey" do
		subject = create_subject
		survey  = Factory(:survey)
		assert_difference("sscount(#{subject.id},#{survey.id})",1){
			Factory(:survey_invitation, {
				:subject => subject, :survey_id => survey.id })
		}
		assert_difference("sscount(#{subject.id},#{survey.id})",0){
		assert_raise(ActiveRecord::RecordInvalid){
			Factory(:survey_invitation, {
				:subject => subject, :survey_id => survey.id })
		} }
	end

	test "her_invitation should return home_exposure_survey invitation" do
		subject = create_subject
		assert_nil subject.her_invitation
		si = Factory(:survey_invitation, 
			:subject => subject,
			:survey  => Survey.first)
		assert_not_nil subject.her_invitation
	end

	test "should NOT destroy survey_invitations with subject" do
		subject = create_subject
		Factory(:survey_invitation, :subject => subject)
		Factory(:survey_invitation, :subject => subject)
		assert_difference( "#{model_name}.count", -1 ) {
		assert_difference('SurveyInvitation.count',0) {
			subject.destroy
		} }
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
		assert_difference( "#{model_name}.count", -1 ) {
		assert_difference('Identifier.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy pii with subject" do
		subject = create_subject
		Factory(:pii, :subject => subject)
		assert_difference( "#{model_name}.count", -1 ) {
		assert_difference('Pii.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy patient with subject" do
#		subject = create_subject
		subject = Factory(:case_subject)
		Factory(:patient, :subject => subject)
		assert_difference( "#{model_name}.count", -1 ) {
		assert_difference('Patient.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy home_exposure_response with subject" do
#		subject = create_subject
#		Factory(:home_exposure_response, :subject => subject)
		subject = Factory(:home_exposure_response).subject
		assert_difference( "#{model_name}.count", -1 ) {
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
		assert_difference( "#{model_name}.count", -1 ) {
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
		assert_difference( "#{model_name}.count", -1 ) {
		assert_difference('Sample.count',0) {
			subject.destroy
		} }
	end

	test "should NOT destroy response_sets with subject" do
		subject = create_subject
		Factory(:response_set, :subject => subject)
		Factory(:response_set, :subject => subject)
		assert_difference( "#{model_name}.count", -1 ) {
		assert_difference('ResponseSet.count',0) {
			subject.destroy
		} }
	end

	test "should return nil ssn without identifier" do
		subject = create_subject
		assert_nil subject.ssn
	end

	test "should return ssn with identifier" do
#		subject = Factory(:identifier, :subject => create_subject).subject
		subject = Factory(:identifier).subject
		assert_not_nil subject.ssn
	end

	test "should return nil full_name without pii" do
		subject = create_subject
		assert_nil subject.full_name
	end

	test "should return full_name with pii" do
		subject = Factory(:pii, :subject => create_subject).subject
		assert_not_nil subject.full_name
	end

	test "should return true response sets the same" do
		sets = create_survey_response_sets
		assert sets.first.subject.response_sets_the_same?
	end

	test "should return false response sets the same" do
		sets = create_survey_response_sets
		sets.last.responses.first.destroy
		assert !sets.first.subject.response_sets_the_same?
	end

	test "should raise error 1 response sets the same" do
		sets = create_survey_response_sets
		sets.last.destroy
		assert_raise(Subject::NotTwoResponseSets) {
			sets.first.subject.response_sets_the_same?
		}
	end

	test "should raise error 3 response sets the same" do
		sets = create_survey_response_sets
		fill_out_survey(:survey => sets.first.survey,
			:subject => sets.first.subject)
		assert_raise(Subject::NotTwoResponseSets) {
			sets.first.subject.response_sets_the_same?
		}
	end

	test "should return diffs on response set diffs" do
		sets = create_survey_response_sets
		sets.last.responses.first.destroy
		assert !sets.first.subject.response_set_diffs.blank?
	end

	test "should return empty diffs on response set diffs when the same" do
		sets = create_survey_response_sets
		assert sets.first.subject.response_set_diffs.blank?
	end

	test "should raise error 1 response set diffs" do
		sets = create_survey_response_sets
		sets.last.destroy
		assert_raise(Subject::NotTwoResponseSets) {
			sets.first.subject.response_set_diffs
		}
	end

	test "should raise error 3 response set diffs" do
		sets = create_survey_response_sets
		fill_out_survey(:survey => sets.first.survey,
			:subject => sets.first.subject)
		assert_raise(Subject::NotTwoResponseSets) {
			sets.first.subject.response_set_diffs
		}
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
		assert_equal subject.race.name, 
			"#{subject.race}"
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

protected

	def create_survey_response_sets
		survey = Survey.find_by_access_code("home_exposure_survey")
		rs1 = fill_out_survey(:survey => survey)
		rs2 = fill_out_survey(:survey => survey,
			:subject => rs1.subject)
		[rs1.reload,rs2.reload]
	end

#	def create_dust_kit(options = {})
#		Factory(:dust_kit, {
#			:kit_package_attributes  => Factory.attributes_for(:package),
#			:dust_package_attributes => Factory.attributes_for(:package) 
#		}.merge(options))
#	end

end
