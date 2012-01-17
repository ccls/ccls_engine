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
		:mom_is_biomom, :dad_is_biodad,
		:mother_hispanicity_mex, :father_hispanicity_mex,
		:reference_date, :mother_yrs_educ, :father_yrs_educ, 
		:birth_type, :birth_county, :is_duplicate_of )

	test "explicit Factory study_subject test" do
		assert_difference('VitalStatus.count',1) {
		assert_difference('SubjectType.count',1) {
		assert_difference('StudySubject.count',1) {
			study_subject = Factory(:study_subject)
			assert_not_nil study_subject.subject_type
			assert_not_nil study_subject.vital_status
			assert_not_nil study_subject.sex
		} } }
	end

	test "explicit Factory case study_subject test" do
		assert_difference('StudySubject.count',1) {
			study_subject = Factory(:case_study_subject)
			assert_equal study_subject.subject_type, SubjectType['Case']
		}
	end

	test "explicit Factory control study_subject test" do
		assert_difference('StudySubject.count',1) {
			study_subject = Factory(:control_study_subject)
			assert_equal study_subject.subject_type, SubjectType['Control']
		}
	end

	test "explicit Factory mother study_subject test" do
		assert_difference('StudySubject.count',1) {
			s = Factory(:mother_study_subject)
			assert_equal s.subject_type, SubjectType['Mother']
			assert_equal s.sex, 'F'
			assert_nil s.identifier
			assert_not_nil s.studyid
			assert_equal 'n/a', s.studyid
		}
	end

	test "explicit Factory complete case study subject build test" do
		assert_difference('Pii.count',0) {
		assert_difference('Patient.count',0) {
		assert_difference('Identifier.count',0) {
		assert_difference('StudySubject.count',0) {
			s = Factory.build(:complete_case_study_subject)
		} } } }
	end

	test "explicit Factory complete case study subject test" do
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
			assert_not_nil s.organization_id
			assert_not_nil s.studyid
			assert_not_nil s.identifier.studyid
			assert_match /\d{4}-C-0/, s.studyid
			assert_match /\d{4}-C-0/, s.identifier.studyid
#	New sequencing make the value of this relatively unpredictable
#			assert_equal s.organization_id, Hospital.first.organization_id
		} } } }
	end

	test "explicit Factory complete waivered case study subject test" do
		assert_difference('Pii.count',1) {
		assert_difference('Patient.count',1) {
		assert_difference('Identifier.count',1) {
		assert_difference('StudySubject.count',1) {
			s = Factory(:complete_waivered_case_study_subject)
			assert_equal s.subject_type, SubjectType['Case']
			assert_equal s.identifier.case_control_type, 'C'
			assert_equal s.identifier.orderno, 0
			assert_not_nil s.identifier.childid
			assert_not_nil s.identifier.patid
			assert_not_nil s.organization_id
			assert s.organization.hospital.has_irb_waiver
		} } } }
	end

	test "explicit Factory complete nonwaivered case study subject test" do
		assert_difference('Pii.count',1) {
		assert_difference('Patient.count',1) {
		assert_difference('Identifier.count',1) {
		assert_difference('StudySubject.count',1) {
			s = Factory(:complete_nonwaivered_case_study_subject)
			assert_equal s.subject_type, SubjectType['Case']
			assert_equal s.identifier.case_control_type, 'C'
			assert_equal s.identifier.orderno, 0
			assert_not_nil s.identifier.childid
			assert_not_nil s.identifier.patid
			assert_not_nil s.organization_id
			assert !s.organization.hospital.has_irb_waiver
		} } } }
	end

	test "should require subject_type" do
		assert_difference( "StudySubject.count", 0 ) do
			study_subject = create_study_subject( :subject_type => nil)
			assert !study_subject.errors.on(:subject_type)
			assert  study_subject.errors.on_attr_and_type?(:subject_type_id,:blank)
		end
	end

	test "should require valid subject_type" do
		assert_difference( "StudySubject.count", 0 ) do
			study_subject = create_study_subject( :subject_type_id => 0)
			assert !study_subject.errors.on(:subject_type_id)
			assert  study_subject.errors.on_attr_and_type?(:subject_type,:blank)
		end
	end

	test "should require sex be either M, F or DK" do
		assert_difference( "StudySubject.count", 0 ) {
			study_subject = create_study_subject(:sex => 'X')
			assert study_subject.errors.on_attr_and_type?(:sex,:inclusion)
		} 
	end

	test "should require sex with custom message" do
		assert_difference( "StudySubject.count", 0 ) do
			study_subject = create_study_subject( :sex => nil )
			assert study_subject.errors.on_attr_and_type?(:sex,:blank)
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

	test "should create study_subject and require address with flag" do
		assert_difference( 'Address.count', 0) {
		assert_difference( 'Addressing.count', 0) {
		assert_difference( "StudySubject.count", 0 ) {
			study_subject = create_study_subject(
				:addressings_attributes => [Factory.attributes_for(:addressing,
					:address_required   => true,
					:address_attributes => { :address_type => AddressType['residence'] } )])
			assert study_subject.errors.on_attr_and_type?('addressings.address.line_1',:blank)
			assert study_subject.errors.on_attr_and_type?('addressings.address.city',:blank)
			assert study_subject.errors.on_attr_and_type?('addressings.address.state',:blank)
			assert study_subject.errors.on_attr_and_type?('addressings.address.zip',:blank)
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

	test "should create study_subject and accept_nested_attributes_for homex_outcome" do
		assert_difference( 'HomexOutcome.count', 1) {
		assert_difference( "StudySubject.count", 1 ) {
			study_subject = create_study_subject(
				:homex_outcome_attributes => Factory.attributes_for(:homex_outcome))
			assert !study_subject.new_record?, 
				"#{study_subject.errors.full_messages.to_sentence}"
		} }
	end

	#	StudySubject currently accepts nested attributes for homex_outcome,
	#	but an empty homex_outcome is no longer invalid.
	test "should create study_subject with empty homex_outcome" do
		assert_difference( 'HomexOutcome.count', 1) {
		assert_difference( 'StudySubject.count', 1) {
			study_subject = create_study_subject( :homex_outcome_attributes => {})
		} }
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

	#
	#	The dependency relationships are left undefined for most models.
	#	Because of this, associated records are neither nullfied nor destroyed
	#	when the associated models is destroyed.
	#

	test "should NOT destroy addressings with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Addressing.count',1) {
			@study_subject = Factory(:addressing).study_subject
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('Addressing.count',0) {
			@study_subject.destroy
		} }
	end

	test "should NOT destroy addresses with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Address.count',1) {
			@study_subject = Factory(:addressing).study_subject
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('Address.count',0) {
			@study_subject.destroy
		} }
	end

	test "should NOT destroy bc_requests with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('BcRequest.count',1) {
			@study_subject = Factory(:study_subject)
			Factory(:bc_request, :study_subject => @study_subject)
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('BcRequest.count',0) {
			@study_subject.destroy
		} }
	end

	test "should NOT destroy enrollments with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Enrollment.count',2) {	#	due to the callback creation of ccls enrollment
			@study_subject = Factory(:enrollment).study_subject
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('Enrollment.count',0) {
			@study_subject.destroy
		} }
	end

	test "should NOT destroy gift_cards with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('GiftCard.count',1) {
			@study_subject = Factory(:study_subject)
			Factory(:gift_card, :study_subject => @study_subject)
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('GiftCard.count',0) {
			@study_subject.destroy
		} }
	end

	test "should NOT destroy home_exposure_response with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('HomeExposureResponse.count',1) {
			@study_subject = Factory(:home_exposure_response).study_subject
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('HomeExposureResponse.count',0) {
			@study_subject.destroy
		} }
	end

	test "should NOT destroy homex_outcome with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('HomexOutcome.count',1) {
			@study_subject = Factory(:study_subject)
			Factory(:homex_outcome, :study_subject => @study_subject)
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('HomexOutcome.count',0) {
			@study_subject.destroy
		} }
	end

	test "should NOT destroy interviews with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Interview.count',1) {
			@study_subject = Factory(:interview).study_subject
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('Interview.count',0) {
			@study_subject.destroy
		} }
	end

	test "should NOT destroy phone_numbers with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('PhoneNumber.count',1) {
			@study_subject = Factory(:phone_number).study_subject
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('PhoneNumber.count',0) {
			@study_subject.destroy
		} }
	end

	test "should NOT destroy samples with study_subject" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Sample.count',1) {
			@study_subject = Factory(:sample).study_subject
		} }
		assert_difference('StudySubject.count',-1) {
		assert_difference('Sample.count',0) {
			@study_subject.destroy
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

	#	All delegated fields
	%w( 
		admit_date organization 
			organization_id hospital_no
		patid orderno ssn childid state_id_no 
			state_registrar_no local_registrar_no
			case_control_type
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

	test "should create_home_exposure_with_study_subject" do
		study_subject = create_home_exposure_with_study_subject
		assert study_subject.is_a?(StudySubject)
	end

	test "should create_home_exposure_with_study_subject with patient" do
		study_subject = create_home_exposure_with_study_subject(:patient => true)
		assert study_subject.is_a?(StudySubject)
	end

	test "should return nil for next_control_orderno for control" do
		study_subject = create_complete_control_study_subject
		assert study_subject.is_control?
		assert_equal nil, study_subject.next_control_orderno
	end

	test "should return nil for next_control_orderno for mother" do
		study_subject = create_complete_mother_study_subject
		assert study_subject.is_mother?
		assert_equal nil, study_subject.next_control_orderno
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

	test "should create mother when isn't one" do
		#	need an identifier when creating mother
		study_subject = create_identifier.study_subject
		assert_nil study_subject.reload.mother
		assert_difference('Pii.count',1) {
		assert_difference('Identifier.count',1) {
		assert_difference('StudySubject.count',1) {
			@mother = study_subject.create_mother
		} } }
		assert_equal @mother, study_subject.mother
	end

	test "should copy mothers names when create mother for case" do
		study_subject = create_complete_case_study_subject(
			:pii_attributes => Factory.attributes_for(:pii,
				:mother_first_name  => 'First',
				:mother_middle_name => 'Middle',
				:mother_last_name   => 'Last',
				:mother_maiden_name => 'Maiden'))
		assert_nil study_subject.reload.mother
		assert_difference('Pii.count',1) {
		assert_difference('Identifier.count',1) {
		assert_difference('StudySubject.count',1) {
			@mother = study_subject.create_mother
			assert_equal @mother.first_name,  'First'
			assert_equal @mother.middle_name, 'Middle'
			assert_equal @mother.last_name,   'Last'
			assert_equal @mother.maiden_name, 'Maiden'
			assert_equal @mother.first_name,  study_subject.mother_first_name
			assert_equal @mother.middle_name, study_subject.mother_middle_name
			assert_equal @mother.last_name,   study_subject.mother_last_name
			assert_equal @mother.maiden_name, study_subject.mother_maiden_name
		} } }
		assert_equal @mother, study_subject.mother
	end

	test "should copy mothers names when create mother for control" do
		study_subject = create_complete_control_study_subject(
			:pii_attributes => Factory.attributes_for(:pii,
				:mother_first_name  => 'First',
				:mother_middle_name => 'Middle',
				:mother_last_name   => 'Last',
				:mother_maiden_name => 'Maiden'))
		assert_nil study_subject.reload.mother
		assert_difference('Pii.count',1) {
		assert_difference('Identifier.count',1) {
		assert_difference('StudySubject.count',1) {
			@mother = study_subject.create_mother
			assert_equal @mother.first_name,  'First'
			assert_equal @mother.middle_name, 'Middle'
			assert_equal @mother.last_name,   'Last'
			assert_equal @mother.maiden_name, 'Maiden'
			assert_equal @mother.first_name,  study_subject.mother_first_name
			assert_equal @mother.middle_name, study_subject.mother_middle_name
			assert_equal @mother.last_name,   study_subject.mother_last_name
			assert_equal @mother.maiden_name, study_subject.mother_maiden_name
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
		study_subject = create_complete_mother_study_subject
		assert_equal study_subject, study_subject.mother
		assert_equal study_subject, study_subject.create_mother
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
		study_subject = create_complete_father_study_subject
		assert_equal study_subject, study_subject.father
		assert_equal study_subject, study_subject.create_father
	end

	test "should get control subjects for case subject" do
		study_subject = create_complete_case_study_subject
		assert_equal [], study_subject.controls	#	aren't any controls, yet
		control = create_control_identifier(:patid => study_subject.patid).study_subject.reload
		assert_equal [control], study_subject.controls
	end

	test "should get other control subjects for control subject" do
		study_subject = create_complete_control_study_subject
		assert_equal [], study_subject.controls
		control = create_control_identifier.study_subject				
		#	both have nil patid so not particularly helpful 'patid = NULL' doesn't work
		assert_equal [], study_subject.controls
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

	test "should return rejected controls for case subject" do
		study_subject = create_complete_case_study_subject
		assert study_subject.is_case?
		assert study_subject.rejected_controls.empty?
		candidate_control = create_rejected_candidate_control(:related_patid => study_subject.patid)
		assert_equal [candidate_control], study_subject.rejected_controls
	end

	test "should return rejected controls for control subject" do
		study_subject = create_complete_control_study_subject
		assert !study_subject.is_case?
		assert  study_subject.is_control?
		assert study_subject.rejected_controls.empty?
		candidate_control = create_rejected_candidate_control(:related_patid => study_subject.patid)
		assert_equal [], study_subject.rejected_controls
	end

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

#
#	As control is created attached to a case, it would be passed
#		a patid and computed orderno.  Creating an identifier on its
#		own would create a partial studyid like '-1-' or something
#		as the only thing the factory would create would be a random
#		case control type.  It should never actually be nil.
#
#	test "should return nil for subjects without studyid" do
#		study_subject = create_identifier(
#			:patid   => '0123', :orderno => 7 ).study_subject.reload
#		assert_nil study_subject.studyid
#	end

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

	test "should return nil for subject's screener_complete_date_for_open_project" <<
			" when subject has no associated operational event type" do
		study_subject = Factory(:study_subject)
		assert_nil study_subject.screener_complete_date_for_open_project
	end

	test "should return date for subject's screener_complete_date_for_open_project" <<
			" when subject has associated operational event type" do
		study_subject = Factory(:study_subject)
		assert_nil study_subject.screener_complete_date_for_open_project
		ccls_enrollment = study_subject.enrollments.find_by_project_id(Project['ccls'].id)
		ccls_enrollment.operational_events.create(
			:operational_event_type_id => OperationalEventType['screener_complete'].id,
			:occurred_on => Date.today)
		date = study_subject.screener_complete_date_for_open_project
		assert_equal date, Date.today
	end

end
