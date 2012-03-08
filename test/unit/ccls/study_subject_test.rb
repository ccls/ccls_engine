require 'test_helper'

class Ccls::StudySubjectTest < ActiveSupport::TestCase

	[ :mom_is_biomom, :dad_is_biodad ].each do |field|

		#	Making assumption that 12345 will NEVER be a valid value.
		test "should NOT allow 12345 for #{field}" do
			study_subject = StudySubject.new(field => 12345)
			study_subject.valid?
			assert study_subject.errors.on_attr_and_type?(field,:inclusion)
		end

		test "should allow nil for #{field}" do
			study_subject = StudySubject.new(field => nil)
			assert_nil study_subject.send(field)
			study_subject.valid?
			assert !study_subject.errors.on(field)
		end

		test "should allow all valid YNDK values for #{field}" do
			study_subject = StudySubject.new
			YNDK.valid_values.each do |value|
				study_subject.send("#{field}=", value)
				study_subject.valid?
				assert !study_subject.errors.on(field)
			end
		end

	end

	assert_should_create_default_object

#	Cannot include enrollments here due to the creation of one
#	during the creation of a study_subject
#	Should create custom check, but this is indirectly tested
#	in the creation of the enrollment so not really needed.
#		:enrollments,

	assert_should_have_many( :samples,
		:gift_cards, :phone_numbers, :interviews, :bc_requests )
	assert_should_initially_belong_to( :subject_type, :vital_status )
	assert_should_have_one( :home_exposure_response, :homex_outcome )
	assert_should_habtm(:analyses)
	assert_should_belong_to( :guardian_relationship, :class_name => 'SubjectRelationship' )

	assert_should_not_require_attributes( :vital_status_id, :hispanicity_id, 
		:mom_is_biomom, :dad_is_biodad,
		:mother_hispanicity_id, :father_hispanicity_id,
		:mother_hispanicity_mex, :father_hispanicity_mex,
		:reference_date, :mother_yrs_educ, :father_yrs_educ, 
		:birth_type, :birth_county, :is_duplicate_of,
		:first_name, :last_name,
		:died_on, :birth_year,
		:birth_city, :birth_state, :birth_country,
		:mother_first_name, :mother_middle_name, :mother_maiden_name, :mother_last_name,
		:father_first_name, :father_middle_name, :father_last_name,
		:guardian_first_name, :guardian_middle_name, :guardian_last_name,
		:guardian_relationship_other, :email,
		:middle_name, :maiden_name,
		:mother_race_other, :father_race_other,
		:generational_suffix, :father_generational_suffix,
		:case_control_type,
		:ssn,
		:subjectid,
		:lab_no,
		:related_childid,
		:related_case_childid,
		:state_id_no,
		:state_registrar_no,
		:local_registrar_no,
		:matchingid,
		:gbid,
		:lab_no_wiemels,
		:accession_no,
		:idno_wiemels,
		:is_matched,
		:familyid )

	assert_should_require_attributes( :dob )

	assert_should_require_unique_attributes( :email,
		:state_id_no,
		:state_registrar_no,
		:local_registrar_no,
		:gbid,
		:lab_no_wiemels,
		:accession_no,
		:idno_wiemels )

	assert_requires_complete_date( :reference_date, :dob, :died_on )
	assert_requires_past_date( :dob )

	assert_should_require_attributes_not_nil( :do_not_contact, :sex )

	assert_should_require_attribute_length( 
		:first_name, :middle_name, :maiden_name, :last_name,
		:mother_first_name, :mother_middle_name, :mother_maiden_name, :mother_last_name,
		:father_first_name, :father_middle_name, :father_last_name,
		:guardian_first_name, :guardian_middle_name, :guardian_last_name,
		:guardian_relationship_other,
		:birth_city, :birth_state, :birth_country,
		:mother_race_other, :father_race_other,
		:state_id_no,
		:state_registrar_no,
		:local_registrar_no,
		:lab_no,
		:related_childid,
		:related_case_childid,
		:maximum => 250 )

	assert_should_require_attribute_length( :gbid, :maximum => 26 )
	assert_should_require_attribute_length( :lab_no_wiemels, :accession_no, 
		:maximum => 25 )
	assert_should_require_attribute_length( :generational_suffix, 
		:father_generational_suffix, :childidwho, :idno_wiemels,
			:maximum => 10 )
	assert_should_require_attribute_length( :icf_master_id, :maximum => 9 )
	assert_should_require_attribute_length( :newid, :maximum => 6 )
	assert_should_require_attribute_length( :birth_year, :maximum => 4 )


#	assert_should_require :hospital_no
#	assert_should_not_require :hospital_no


	assert_should_protect_attributes(
		:studyid,
		:studyid_nohyphen,
		:studyid_intonly_nohyphen,
		:familyid,
		:childid,
		:subjectid,
		:patid )







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
			assert_nil     s.studyid
			assert_not_nil s.studyid_to_s
			assert_equal 'n/a', s.studyid_to_s
		}
	end

	test "explicit Factory complete case study subject build test" do
		assert_difference('Patient.count',0) {
		assert_difference('StudySubject.count',0) {
			s = Factory.build(:complete_case_study_subject)
		} }
	end

	test "explicit Factory complete case study subject test" do
		assert_difference('Patient.count',1) {
		assert_difference('StudySubject.count',1) {
			s = Factory(:complete_case_study_subject)
			assert_equal s.subject_type, SubjectType['Case']
			assert_equal s.case_control_type, 'C'
			assert_equal s.orderno, 0
			assert_not_nil s.childid
			assert_not_nil s.patid
			assert_not_nil s.organization_id
			assert_not_nil s.studyid
			assert_not_nil s.studyid
			assert_match /\d{4}-C-0/, s.studyid
#	New sequencing make the value of this relatively unpredictable
#			assert_equal s.organization_id, Hospital.first.organization_id
		} }
	end

	test "explicit Factory complete waivered case study subject test" do
		assert_difference('Patient.count',1) {
		assert_difference('StudySubject.count',1) {
			s = Factory(:complete_waivered_case_study_subject)
			assert_equal s.subject_type, SubjectType['Case']
			assert_equal s.case_control_type, 'C'
			assert_equal s.orderno, 0
			assert_not_nil s.childid
			assert_not_nil s.patid
			assert_not_nil s.organization_id
			assert s.organization.hospital.has_irb_waiver
		} }
	end

	test "explicit Factory complete nonwaivered case study subject test" do
		assert_difference('Patient.count',1) {
		assert_difference('StudySubject.count',1) {
			s = Factory(:complete_nonwaivered_case_study_subject)
			assert_equal s.subject_type, SubjectType['Case']
			assert_equal s.case_control_type, 'C'
			assert_equal s.orderno, 0
			assert_not_nil s.childid
			assert_not_nil s.patid
			assert_not_nil s.organization_id
			assert !s.organization.hospital.has_irb_waiver
		} }
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

	test "should belong to vital_status" do
		study_subject = create_study_subject(:vital_status => nil)
		assert_nil study_subject.vital_status
		study_subject.vital_status = Factory(:vital_status)
		assert_not_nil study_subject.vital_status
	end

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

#	test "should have many samples through enrollments" do
#		assert_difference('StudySubject.count',1) {
#		assert_difference('Enrollment.count',2) {
#		assert_difference('Sample.count',1) {
#			sample = Factory(:sample)
##			subject = sample.enrollment.study_subject
#			subject = sample.study_subject
#			assert subject.samples.include?(sample)
#		} } }
#	end

	test "should have and belong to many analyses" do
		study_subject = create_study_subject
		assert_equal 0, study_subject.analyses.length
		study_subject.analyses << Factory(:analysis)
		assert_equal 1, study_subject.reload.analyses.length
		study_subject.analyses << Factory(:analysis)
		assert_equal 2, study_subject.reload.analyses.length
	end

	test "should return subject_type description for string" do
		study_subject = create_study_subject
		assert_equal study_subject.subject_type.description,
			"#{study_subject.subject_type}"
	end

	test "should not be case unless explicitly told" do
		study_subject = create_study_subject
		assert !study_subject.is_case?
	end

	test "should case if explicitly told" do
		study_subject = Factory(:case_study_subject)
		assert study_subject.is_case?
	end

	test "should return concat of 3 fields as to_s" do
		study_subject = create_study_subject
		#	[childid,'(',studyid,full_name,')'].compact.join(' ')
		assert_equal "#{study_subject}",
			[study_subject.childid,'(',study_subject.studyid,study_subject.full_name,')'].compact.join(' ')
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
		case_study_subject = create_case_study_subject
		assert_equal 1, case_study_subject.next_control_orderno
	end

	test "should return 2 for next_control_orderno for case with one control" do
		case_study_subject = create_case_study_subject
		assert_equal 1, case_study_subject.next_control_orderno
		control = create_control_study_subject(
			:matchingid => case_study_subject.subjectid,
			:case_control_type => '6',	#	<- default used for next_control_orderno
			:orderno    => case_study_subject.next_control_orderno )
		assert_equal 2, case_study_subject.next_control_orderno
	end

	test "should create mother when isn't one" do
		study_subject = create_complete_control_study_subject
		assert_nil study_subject.mother
		assert_difference('StudySubject.count',1) {
			@mother = study_subject.create_mother
		}
		assert_equal @mother, study_subject.mother
	end

	test "should copy mothers names when create mother for case" do
		study_subject = create_complete_case_study_subject(
			:mother_first_name  => 'First',
			:mother_middle_name => 'Middle',
			:mother_last_name   => 'Last',
			:mother_maiden_name => 'Maiden')
		assert_nil study_subject.reload.mother
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
		}
		assert_equal @mother, study_subject.mother
	end

	test "should copy mothers names when create mother for control" do
		study_subject = create_complete_control_study_subject(
			:mother_first_name  => 'First',
			:mother_middle_name => 'Middle',
			:mother_last_name   => 'Last',
			:mother_maiden_name => 'Maiden')
		assert_nil study_subject.reload.mother
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
		}
		assert_equal @mother, study_subject.mother
	end

	test "should copy mother_hispanicity_id when create mother for case" do
		study_subject = create_complete_case_study_subject(
			:mother_hispanicity_id => 123)
		assert_equal study_subject.mother_hispanicity_id, 123
		assert_nil study_subject.reload.mother
		assert_difference('StudySubject.count',1) {
			@mother = study_subject.create_mother
			assert_equal @mother.hispanicity_id, 123
		}
		assert_equal @mother, study_subject.mother
	end

	test "should copy mother_hispanicity_id when create mother for control" do
		study_subject = create_complete_control_study_subject(
			:mother_hispanicity_id => 123)
		assert_equal study_subject.mother_hispanicity_id, 123
		assert_nil study_subject.reload.mother
		assert_difference('StudySubject.count',1) {
			@mother = study_subject.create_mother
			assert_equal @mother.hispanicity_id, 123
		}
		assert_equal @mother, study_subject.mother
	end

	test "should not create mother when one exists" do
		study_subject = create_complete_control_study_subject
		mother = study_subject.create_mother
		assert_difference('StudySubject.count',0) {
			@mother = study_subject.create_mother
		}
		assert_equal @mother, mother
	end

	test "should not create mother for mother" do
		study_subject = Factory(:complete_mother_study_subject)
		assert_nil study_subject.familyid
		assert_nil study_subject.mother
		assert_equal study_subject, study_subject.create_mother
	end

#	test "should not create mother for subject without identifier" do
#		study_subject = Factory(:study_subject)
#		assert_nil study_subject.identifier
##	TODO raise an error?
##		mother = study_subject.create_mother
##flunk
#	end

	test "should get control subjects for case subject" do
		study_subject = create_complete_case_study_subject
		assert_equal [], study_subject.controls	#	aren't any controls, yet
		control = create_control_study_subject(
			:patid => study_subject.patid).reload
		assert_equal [control], study_subject.controls
	end

	test "should get other control subjects for control subject" do
		study_subject = create_complete_control_study_subject
		assert_equal [], study_subject.controls
		control = create_control_study_subject				
		#	both have nil patid so not particularly helpful 'patid = NULL' doesn't work
		assert_equal [], study_subject.controls
	end


#
#	matching/matchingid is for matching cases and controls
#		This will also include case's family
#
	test "should NOT include self in matching for case" do
		study_subject = create_complete_case_study_subject
		assert study_subject.is_case?
		assert_equal 0, study_subject.matching.length
	end

	test "should NOT include self in matching for control" do
		study_subject = create_complete_control_study_subject
		assert study_subject.is_control?
		assert_equal 0, study_subject.matching.length
	end

	test "should include mother in matching for case" do
		study_subject = create_complete_case_study_subject
		assert study_subject.is_case?
		assert_not_nil study_subject.matchingid
		mother = study_subject.create_mother
		assert_equal study_subject.matching.length, 1
		assert       study_subject.matching.include?(mother)
	end

	test "should NOT include mother in matching for control" do
		study_subject = create_complete_control_study_subject
		assert study_subject.is_control?
		assert_nil study_subject.matchingid
		mother = study_subject.create_mother
		assert_equal 0, study_subject.matching.length
	end

	test "should return nothing for null matchingid for matching" do
		#	only case is auto-assigned a matchingid
		study_subject = Factory(:study_subject)
		assert_nil study_subject.matchingid
		assert_equal study_subject.matching.length, 0
	end


#
#	family/familyid is for matching subject to family members
#
	test "should NOT include self in family for case" do
		study_subject = create_complete_case_study_subject
		assert study_subject.is_case?
		assert_equal 0, study_subject.family.length
	end

	test "should NOT include self in family for control" do
		study_subject = create_complete_control_study_subject
		assert study_subject.is_control?
		assert_equal 0, study_subject.family.length
	end

	test "should include mother in family for case" do
		study_subject = create_complete_case_study_subject
		assert study_subject.is_case?
		mother = study_subject.create_mother
		assert_equal study_subject.family.length, 1
		assert       study_subject.family.include?(mother)
	end

	test "should include mother in family for control" do
		study_subject = create_complete_control_study_subject
		assert study_subject.is_control?
		mother = study_subject.create_mother
		assert_equal study_subject.family.length, 1
		assert       study_subject.family.include?(mother)
	end

	test "should return nothing for null familyid for family" do
		#	only a mother won't be assigned a familyid
		study_subject = Factory(:mother_study_subject)
		assert_nil study_subject.familyid
		assert_equal study_subject.family.length, 0
	end


	test "should return nil for mother with nil familyid" do
		#	only a mother won't be assigned a familyid
		study_subject = Factory(:mother_study_subject)
		assert_nil study_subject.familyid
		assert_nil study_subject.mother
	end

	test "should return mother if is one" do
#	TODO maybe return nil instead of self?
		study_subject = Factory(:complete_control_study_subject)
		assert_nil study_subject.mother
		mother = study_subject.create_mother
		assert_not_nil study_subject.mother
		assert_equal mother, study_subject.mother
	end


	test "should return rejected controls for case subject" do
		study_subject = Factory(:complete_case_study_subject)
		assert study_subject.is_case?
		assert study_subject.rejected_controls.empty?
		candidate_control = create_rejected_candidate_control(
			:related_patid => study_subject.patid)
		assert_equal [candidate_control], study_subject.rejected_controls
	end

	test "should return rejected controls for control subject" do
		study_subject = Factory(:complete_control_study_subject)
		assert !study_subject.is_case?
		assert  study_subject.is_control?
		assert study_subject.rejected_controls.empty?
		candidate_control = create_rejected_candidate_control(
			:related_patid => study_subject.patid)
		assert_equal [], study_subject.rejected_controls
	end

	test "should return case by patid" do
		Factory(:case_study_subject)	#	just another for noise
		study_subject = Factory(:case_study_subject)
		found_study_subject = StudySubject.find_case_by_patid(study_subject.patid)
		assert_not_nil found_study_subject
		assert_equal study_subject, found_study_subject
	end

	test "should return nothing if no case matching patid" do
		study_subject = Factory(:case_study_subject)
		found_study_subject = StudySubject.find_case_by_patid('0000')
		assert_nil found_study_subject
	end

	test "should return child if subject is mother of case" do
		study_subject = Factory(:complete_case_study_subject)
		mother = study_subject.create_mother
		assert_equal mother, study_subject.mother
		assert_equal mother.child, study_subject
	end

	test "should return child if subject is mother of control" do
		study_subject = Factory(:complete_control_study_subject)
		mother = study_subject.create_mother
		assert_equal mother, study_subject.mother
		assert_equal mother.child, study_subject
	end

	test "should return nil for child if is not mother" do
		study_subject = Factory(:complete_control_study_subject)
		assert_nil study_subject.child
	end

	test "should return appended child's childid if is mother" do
		study_subject = Factory(:complete_control_study_subject)
		mother = study_subject.create_mother
		assert_not_nil study_subject.childid
		assert_nil     mother.childid
		assert_not_nil mother.childid_to_s
		assert_equal "#{study_subject.childid} (mother)", mother.childid_to_s
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
		study_subject = Factory(:complete_control_study_subject)
		mother = study_subject.create_mother
		assert_nil          mother.studyid
		assert_equal 'n/a', mother.studyid_to_s
	end

end
