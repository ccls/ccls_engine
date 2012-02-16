def random_pos_neg
	[nil,1,2][rand(3)]
end
def random_true_or_false
	[true,false][rand(2)]
end
def random_yndk
	[nil,1,2,999][rand(4)]
end
def random_date
	Date.jd(2440000+rand(15000))
end
def random_float
	rand * 100
end
def random_sex
	%w( M F )[rand(2)]
end

#	This is no longer used in this gem, but is used in the apps
Factory.define :page do |f|
	f.sequence(:path)    { |n| "/path#{n}" }
	f.sequence(:menu_en) { |n| "Menu #{n}" }
	f.sequence(:title_en){ |n| "Title #{n}" }
	f.body_en  "Page Body"
end

Factory.define :user do |f|
	f.sequence(:uid) { |n| "UID#{n}" }
#	f.sequence(:username) { |n| "username#{n}" }
#	f.sequence(:email) { |n| "username#{n}@example.com" }
#	f.password 'V@1!dP@55w0rd'
#	f.password_confirmation 'V@1!dP@55w0rd'
#	f.role_name 'user'
end
Factory.define :admin_user, :parent => :user do |f|
	f.administrator true
end	#	parent must be defined first

Factory.define :address do |f|
	f.association :address_type
	f.sequence(:line_1) { |n| "Box #{n}" }
	f.city "Berkeley"
	f.state "CA"
	f.zip "12345"
end
Factory.define :mailing_address, :parent => :address do |f|
	f.address_type { AddressType['mailing'] }
end
Factory.define :residence_address, :parent => :address do |f|
	f.address_type { AddressType['residence'] }
end

Factory.define :addressing do |f|
	f.association :address
	f.association :study_subject
	f.is_valid    1
	f.is_verified false		#		2		#	20111110 just noticed that this is boolean and not int for YNDK
	f.updated_at Time.now	#	to make it dirty
end
Factory.define :mailing_addressing, :parent => :addressing do |f|
	f.association :address, :factory => :mailing_address
	f.current_address { YNDK[:no] }
end
Factory.define :current_mailing_addressing, :parent => :mailing_addressing do |f|
	f.association :address, :factory => :mailing_address
	f.current_address { YNDK[:yes] }
end
Factory.define :residence_addressing, :parent => :addressing do |f|
	f.association :address, :factory => :residence_address
	f.current_address { YNDK[:no] }
end
Factory.define :current_residence_addressing, :parent => :residence_addressing do |f|
	f.association :address, :factory => :residence_address
	f.current_address { YNDK[:yes] }
end

Factory.define :address_type do |f|
	f.sequence(:code) { |n| "Code#{n}" }
end

Factory.define :aliquot do |f|
	f.association :sample
	f.association :unit
	f.association :owner, :factory => :organization
end

Factory.define :aliquot_sample_format do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :analysis do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :bc_request do |f|
	f.sequence(:notes) { |n| "Notes#{n}" }	#	forces an update
end

Factory.define :candidate_control do |f|
	f.first_name "First"
	f.last_name  "Last"
	f.dob { random_date }	#Date.jd(2440000+rand(15000))
	f.reject_candidate false
	f.sex { random_sex }
end
Factory.define :rejected_candidate_control, :parent => :candidate_control do |f|
	f.reject_candidate true
	f.rejection_reason "Some test reason"
end

Factory.define :context do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :context_data_source do |f|
	f.association :context
	f.association :data_source
end

Factory.define :county do |f|
	f.sequence(:name){ |n| "Name #{n}" }
	f.state_abbrev 'XX'
end

Factory.define :data_source do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :diagnosis do |f|
	f.sequence(:key)         { |n| "key#{n}"}
	f.sequence(:code)        { |n| n+4 }	#	1, 2 and 3 are in the fixtures
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :document_type do |f|
	f.sequence(:title) { |n| "Title#{n}" }
end

Factory.define :document_version do |f|
	f.sequence(:title) { |n| "Title#{n}" }
	f.association :document_type
end

Factory.define :subjectless_enrollment, :class => 'Enrollment' do |f|
	f.association :project
end
Factory.define :enrollment, :parent => :subjectless_enrollment do |f|
	f.association :study_subject
#	f.association :project
#	f.is_eligible 1	#true
#	f.is_chosen   1	#true
#	f.consented   1	#true
#	f.consented_on Date.yesterday
#	f.terminated_participation 2	#false
#	f.is_complete 2	#false
end
Factory.define :consented_enrollment, :parent => :enrollment do |f|
	f.consented   { YNDK[:yes] }	#1	#true
	f.consented_on Date.yesterday
end
Factory.define :declined_enrollment, :parent => :enrollment do |f|
	f.consented   { YNDK[:no] }	#	2
	f.consented_on Date.yesterday
	f.association :refusal_reason
end

Factory.define :follow_up do |f|
	f.association :section
	f.association :enrollment
	f.association :follow_up_type
end

Factory.define :follow_up_type do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :gift_card do |f|
	f.sequence(:number){ |n| "#{n}" }
end

#	This is no longer used in this gem, but is used in the apps
Factory.define :guide do |f|
	f.sequence(:controller){ |n| "controller#{n}" }
	f.sequence(:action)    { |n| "action#{n}" }
	f.sequence(:body)      { |n| "Body #{n}" }
end

Factory.define :home_exposure_response do |f|
	f.association :study_subject
end

Factory.define :homex_outcome do |f|
	#	20111110 - don't know why this was explicitly set
	#	They are explicitly set solely for testing OTHER models.
	#	interview_outcome_on is required for the InterviewOutcome test
	#	sample_outcome_on is required for the SampleOutcome test
	f.sample_outcome_on Date.today		
	f.interview_outcome_on Date.today
end

Factory.define :hospital do |f|
	f.association :organization
end
Factory.define :waivered_hospital, :parent => :hospital do |f|
	f.has_irb_waiver true
end
Factory.define :nonwaivered_hospital, :parent => :hospital do |f|
	f.has_irb_waiver false
end

Factory.define :icf_master_id do |f|
end

Factory.define :icf_master_tracker do |f|
	f.sequence(:Masterid){|n| "#{n}"}	#	in order to test uniqueness, MUST BE HERE
end
Factory.define :icf_master_tracker_update do |f|
end

Factory.define :subjectless_identifier, :class => 'Identifier' do |f|
#	f.sequence(:ssn){|n| sprintf("%09d",n) }
	#	technically, this makes this a control identifier
	f.sequence(:case_control_type){|n| '123456789'.split('')[n%9] }
	f.sequence(:state_id_no){|n| "#{n}"}
	f.sequence(:state_registrar_no){|n| "#{n}"}
	f.sequence(:local_registrar_no){|n| "#{n}"}
	f.sequence(:gbid){|n| "#{n}"}
	f.sequence(:accession_no){|n| "#{n}"}
	f.sequence(:lab_no_wiemels){|n| "#{n}"}
	f.sequence(:idno_wiemels){|n| "#{n}"}
#	f.sequence(:icf_master_id){|n| "#{n}"}	#	in order to test uniqueness, MUST BE HERE
end
Factory.define :identifier, :parent => :subjectless_identifier do |f|
	f.association :study_subject
end
Factory.define :case_identifier, :parent => :identifier do |f|
	f.association :study_subject, :factory => :case_study_subject
	f.case_control_type 'c'
end
Factory.define :control_identifier, :parent => :identifier do |f|
	f.association :study_subject, :factory => :control_study_subject
end
Factory.define :mother_identifier, :parent => :identifier do |f|
	f.association :study_subject, :factory => :mother_study_subject
	f.case_control_type 'm'
end
#Factory.define :father_identifier, :parent => :identifier do |f|
#	f.association :study_subject, :factory => :father_study_subject
##	f.case_control_type 'm'
#end

Factory.define :ineligible_reason do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :instrument do |f|
	f.association :project
	f.sequence(:code)        { |n| "Code#{n}" }
	f.name 'Instrument Name'
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :instrument_type do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
	f.association :project
end

Factory.define :instrument_version do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
	f.association :instrument_type
end

Factory.define :interview_method do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :interview_outcome do |f|
	f.sequence(:code) { |n| "Code#{n}" }
end

Factory.define :interview do |f|
	f.association :study_subject
end

Factory.define :live_birth_data_update do |f|
end

Factory.define :language do |f|
	f.sequence(:key)         { |n| "Key#{n}" }
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :operational_event do |f|
	f.association :enrollment, :factory => :subjectless_enrollment
	f.association :operational_event_type
end

Factory.define :operational_event_type do |f|
	f.sequence(:code)           { |n| "Code#{n}" }
	f.sequence(:description)    { |n| "Desc#{n}" }
	f.sequence(:event_category) { |n| "Cat#{n}" }
end

Factory.define :organization do |f|
	f.sequence(:code) { |n| "Code #{n}" }
	f.sequence(:name) { |n| "Name #{n}" }
end

#Factory.define :package do |f|
##	f.carrier "FedEx"
#	f.sequence(:tracking_number) { |n| "ABC123#{n}" }
#end

Factory.define :subjectless_patient, :class => 'Patient' do |f|
	#	Today should always be after the dob.
	#	However, with all of the date chronology tests, still may cause problems.
	f.admit_date Date.today	

	#	in order to test presence or uniqueness, MUST BE HERE
	f.sequence(:hospital_no){|n| "#{n}"}	

	#	Doing it this way will actually include organization_id 
	#	in the Factory.attributes_for(:patient) method.
	#	Of course, it requires that there actually be an Organization.
	#	f.association :organization
	#	f.organization { Organization.first }
	#	f.organization_id { Organization.first.id }

#	f.organization_id { Hospital.first.organization_id }		#	make this a sequence rather than just first?
#	This sequence seems to work, but lets see if it has any repercusions.  May have to modify
#	some other existing tests that may have expected it not to change.
	f.sequence(:organization_id){|n| Hospital.all()[ n % Hospital.count ].organization_id }

	f.diagnosis_id { Diagnosis['ALL'].id }
end
Factory.define :patient, :parent => :subjectless_patient do |f|
	#	really don't see the point of a patient w/o a study_subject
	f.association :study_subject, :factory => :case_study_subject
end
Factory.define :waivered_patient, :parent => :patient do |f|
#	f.organization_id { Hospital.waivered.first.organization_id }		#	make this a sequence rather than just first?
	f.sequence(:organization_id){|n| Hospital.waivered()[ n % Hospital.waivered.length ].organization_id }
end
Factory.define :nonwaivered_patient, :parent => :patient do |f|
#	f.organization_id { Hospital.nonwaivered.first.organization_id }		#	make this a sequence rather than just first?
	f.sequence(:organization_id){|n| Hospital.nonwaivered()[ n % Hospital.nonwaivered.length ].organization_id }
end

Factory.define :person do |f|
	#	use sequence so will actually update
	f.sequence(:last_name){|n| "LastName#{n}"}	
end

Factory.define :phone_number do |f|
	f.association :study_subject
	f.association :phone_type
	f.sequence(:phone_number){|n| sprintf("%010d",n) }
	f.is_valid    1
	f.is_verified false		#		2		#	20111110 just noticed that this is boolean and not int for YNDK
end

Factory.define :phone_type do |f|
	f.sequence(:code) { |n| "Code#{n}" }
#	f.sequence(:description) { |n| "Desc#{n}" }
end

#Factory.define :subjectless_pii, :class => 'Pii' do |f|
#	f.sequence(:email){|n| "email#{n}@example.com"}	#	required here only to test uniqueness
#	f.dob { random_date }	#Date.jd(2440000+rand(15000))
#end
#Factory.define :pii, :parent => :subjectless_pii do |f|
#	f.association :study_subject
#end
#Factory.define :case_pii, :parent => :pii do |f|
#	f.association :study_subject, :factory => :case_study_subject
#end

Factory.define :project_outcome do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :project do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :race do |f|
	f.sequence(:key)        {|n| "key#{n}"}
	f.sequence(:code)       {|n| "Race#{n}"}
	f.sequence(:description){|n| "Desc#{n}"}
end

Factory.define :refusal_reason do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :sample_kit do |f|
	f.association :sample
end

Factory.define :sample_outcome do |f|
	f.sequence(:code) { |n| "Code#{n}" }
end

Factory.define :sample do |f|
	f.association :study_subject
	f.association :sample_type
end

Factory.define :sample_type do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
	f.association :parent, :factory => :sample_type_parent
end
Factory.define :sample_type_parent, :parent => :sample_type do |f|
	f.parent nil
end

Factory.define :section do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :state do |f|
	f.sequence(:code) { |n| "Code#{n}" }
	f.sequence(:name) { |n| "Name#{n}" }
#	This is just one character so looping through known unused chars.
#	This is potentially a problem causer in testing.
#	fips_state_code is actually 2 chars so could add something
#	36 squared is pretty big so  ....
	f.sequence(:fips_state_code){|n|
#		n += 56	#	56 appears to be the highest code used
		'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')[n/26] <<
		'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')[n%26] }
#		'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')[n/36] <<
#		'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')[n%36] }
	f.fips_country_code 'US'
end

Factory.define :study_subject do |f|
	f.association :subject_type
	f.association :vital_status
	f.sex { random_sex }
	f.sequence(:email){|n| "email#{n}@example.com"}	#	required here only to test uniqueness
	f.dob { random_date }	#Date.jd(2440000+rand(15000))
end
Factory.define :case_study_subject, :parent => :study_subject do |f|
	f.subject_type { SubjectType['Case'] }
end
Factory.define :complete_case_study_subject, :parent => :case_study_subject do |f|
	#	wrap in {} so is a proc/lambda and runs at runtime NOT at definition
	#	when the fixtures have been loaded and these will work.
	#	Only really needed for patient as gets Hospital and Diagnosis.

#	in parent so shouldn't be needed here
#	f.subject_type { SubjectType['Case'] }

#	f.pii { Factory.build(:subjectless_pii) }
#	f.patient { Factory.build(:subjectless_patient) }
#	f.identifier { Factory.build(:subjectless_identifier,
#		:case_control_type => 'C' ) }
#	Either by building subjectless versions(above) or 
#		with nested attributes(below). Both seem to work.
#	The model must be set to accept nested attributes for
#		those versions to actually work though.
#	Using the nested attributes makes for easier merging.
#	Actually, this mucks up sequencing.  Calling this factory twice results in uniqueness validation failures.
#	If these calls are wrapped in {}, the sequencing is fine.  Its all about when its called
#		and the {} delay the execution of the Factory.attributes_for
#	f.pii_attributes { Factory.attributes_for(:pii) }	#	as this is attributes_for, doesn't need to be "subjectless_pii"
	f.patient_attributes { Factory.attributes_for(:patient) }
	f.identifier_attributes { Factory.attributes_for(:case_identifier) }
end
Factory.define :complete_waivered_case_study_subject, :parent => :complete_case_study_subject do |f|
	f.patient_attributes { Factory.attributes_for(:waivered_patient) }
end
Factory.define :complete_nonwaivered_case_study_subject, :parent => :complete_case_study_subject do |f|
	f.patient_attributes { Factory.attributes_for(:nonwaivered_patient) }
end
Factory.define :control_study_subject, :parent => :study_subject do |f|
	f.subject_type { SubjectType['Control'] }
end
Factory.define :complete_control_study_subject, :parent => :control_study_subject do |f|
	#	as these are attributes_for, don't need to be "subjectless_*"
#	f.pii_attributes { Factory.attributes_for(:pii) }	
	f.identifier_attributes { Factory.attributes_for(:control_identifier) }
end
Factory.define :mother_study_subject, :parent => :study_subject do |f|
	f.subject_type { SubjectType['Mother'] }
	f.sex 'F'
end
Factory.define :complete_mother_study_subject, :parent => :mother_study_subject do |f|
	#	as these are attributes_for, don't need to be "subjectless_*"
#	f.pii_attributes { Factory.attributes_for(:pii) }	
	f.identifier_attributes { Factory.attributes_for(:mother_identifier) }
end
#Factory.define :father_study_subject, :parent => :study_subject do |f|
#	f.subject_type { SubjectType['Father'] }
#	f.sex 'M'
#end
#Factory.define :complete_father_study_subject, :parent => :father_study_subject do |f|
#	#	as these are attributes_for, don't need to be "subjectless_*"
#	f.pii_attributes { Factory.attributes_for(:pii) }	
#	f.identifier_attributes { Factory.attributes_for(:father_identifier) }
#end

Factory.define :subject_language do |f|
	f.association :study_subject
	f.association :language
end

Factory.define :subject_race do |f|
	f.association :study_subject
	f.association :race
end

Factory.define :subject_relationship do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :subject_type do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

#Factory.define :track do |f|
#	f.association :trackable, :factory => :package
#	f.name "Name"
#	f.time Time.now
#end

Factory.define :transfer do |f|
	f.association :from_organization, :factory => :organization
	f.association :to_organization,   :factory => :organization
	f.association :aliquot
end

Factory.define :unit do |f|
	f.sequence(:code)        { |n| "Code#{n}" }
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :vital_status do |f|
	f.sequence(:key)         { |n| "key#{n}" }
	f.sequence(:code)        { |n| n+3 }							#	3 in fixtures
	f.sequence(:description) { |n| "Desc#{n}" }
end

Factory.define :zip_code do |f|
	f.sequence(:zip_code){ |n| sprintf("X%04d",n) }
#	f.latitude { random_float() }
#	f.longitude { random_float() }
	f.sequence(:city){ |n| sprintf("%05d",n) }
	f.sequence(:state){ |n| sprintf("%05d",n) }
#	f.sequence(:county){ |n| sprintf("%05d",n) }
	f.zip_class "TESTING"
end


#
#		Intended for communication with SRC,
#		but that doesn't look like it'll be happening now.
#
Factory.define :import do |f|
end
Factory.define :export do |f|
	f.sequence(:childid) { |n| "childid#{n}" }
	f.sequence(:patid)   { |n| "patid#{n}" }
end



Factory.define :abstract do |f|
	f.updated_at Time.now	#	to make it dirty
end
Factory.define :complete_abstract, :class => 'Abstract' do |f|
#	f.sequence(:subject_id){|n| n }
	f.response_day14or28_flag { random_yndk() }
	f.received_bone_marrow_biopsy { random_yndk() }
	f.received_h_and_p { random_yndk() }
	f.received_other_reports { random_yndk() }
	f.received_discharge_summary { random_yndk() }
	f.received_chemo_protocol { random_yndk() }
	f.received_resp_to_therapy { random_yndk() }
	f.sequence(:received_specify_other_reports){|n| "#{n}"}
	f.received_bone_marrow_aspirate { random_yndk() }
	f.received_flow_cytometry { random_yndk() }
	f.received_ploidy { random_yndk() }
	f.received_hla_typing { random_yndk() }
	f.received_cytogenetics { random_yndk() }
	f.received_cbc { random_yndk() }
	f.received_csf { random_yndk() }
	f.received_chest_xray { random_yndk() }
	f.response_report_found_day_14 { random_yndk() }
	f.response_report_found_day_28 { random_yndk() }
	f.response_report_found_day_7 { random_yndk() }
	f.response_report_on_day_14 { random_date() }
	f.response_report_on_day_28 { random_date() }
	f.response_report_on_day_7  { random_date() }
	f.sequence(:response_classification_day_14){|n| "#{n}"}
	f.sequence(:response_classification_day_28){|n| "#{n}"}
	f.sequence(:response_classification_day_7){|n| "#{n}"}
	f.sequence(:response_blasts_day_14){|n| n }
	f.sequence(:response_blasts_day_28){|n| n }
	f.sequence(:response_blasts_day_7){|n| n }
	f.sequence(:response_blasts_units_day_14){|n| "#{n}"}
	f.sequence(:response_blasts_units_day_28){|n| "#{n}"}
	f.sequence(:response_blasts_units_day_7){|n| "#{n}"}
	f.sequence(:response_in_remission_day_14){|n| n }
	f.marrow_biopsy_report_found { random_yndk() }
	f.marrow_biopsy_on { random_date() }
	f.sequence(:marrow_biopsy_diagnosis){|n| "#{n}"}
	f.marrow_aspirate_report_found { random_yndk() }
	f.marrow_aspirate_taken_on { random_date() }
	f.sequence(:marrow_aspirate_diagnosis){|n| "#{n}"}
	f.sequence(:response_marrow_kappa_day_14){|n| n }
	f.sequence(:response_marrow_kappa_day_7){|n| n }
	f.sequence(:response_marrow_lambda_day_14){|n| n }
	f.sequence(:response_marrow_lambda_day_7){|n| n }
	f.cbc_report_found { random_yndk() }
	f.cbc_report_on { random_date() }
	f.cbc_white_blood_count { rand*1000 }
	f.sequence(:cbc_percent_blasts){|n| n }
	f.cbc_percent_blasts_unknown { random_true_or_false() }
	f.sequence(:cbc_number_blasts){|n| n }
	f.cbc_hemoglobin_level { rand*1000 }
	f.sequence(:cbc_platelet_count){|n| n }
	f.cerebrospinal_fluid_report_found { random_yndk() }
	f.csf_report_on { random_date() }
	f.sequence(:csf_white_blood_count){|n| n }
	f.sequence(:csf_white_blood_count_text){|n| "#{n}"}
	f.sequence(:csf_red_blood_count){|n| n }
	f.sequence(:csf_red_blood_count_text){|n| "#{n}"}
	f.sequence(:blasts_are_present){|n| "#{n}"}
	f.sequence(:number_of_blasts){|n| n }
	f.sequence(:peripheral_blood_in_csf){|n| "#{n}"}
	f.sequence(:csf_comment){|n| "#{n}"}
	f.chemo_protocol_report_found { random_yndk() }
	f.patient_on_chemo_protocol { random_yndk() }
	f.sequence(:chemo_protocol_name){|n| "#{n}"}
	f.sequence(:chemo_protocol_agent_description){|n| "#{n}"}
	f.sequence(:response_cd10_day_14){|n| "#{n}"}
	f.sequence(:response_cd10_day_7){|n| "#{n}"}
	f.sequence(:response_cd13_day_14){|n| "#{n}"}
	f.sequence(:response_cd13_day_7){|n| "#{n}"}
	f.sequence(:response_cd14_day_14){|n| "#{n}"}
	f.sequence(:response_cd14_day_7){|n| "#{n}"}
	f.sequence(:response_cd15_day_14){|n| "#{n}"}
	f.sequence(:response_cd15_day_7){|n| "#{n}"}
	f.sequence(:response_cd19_day_14){|n| "#{n}"}
	f.sequence(:response_cd19_day_7){|n| "#{n}"}
	f.sequence(:response_cd19cd10_day_14){|n| "#{n}"}
	f.sequence(:response_cd19cd10_day_7){|n| "#{n}"}
	f.sequence(:response_cd1a_day_14){|n| "#{n}"}
	f.sequence(:response_cd2a_day_14){|n| "#{n}"}
	f.sequence(:response_cd20_day_14){|n| "#{n}"}
	f.sequence(:response_cd20_day_7){|n| "#{n}"}
	f.sequence(:response_cd3a_day_14){|n| "#{n}"}
	f.sequence(:response_cd3_day_7){|n| "#{n}"}
	f.sequence(:response_cd33_day_14){|n| "#{n}"}
	f.sequence(:response_cd33_day_7){|n| "#{n}"}
	f.sequence(:response_cd34_day_14){|n| "#{n}"}
	f.sequence(:response_cd34_day_7){|n| "#{n}"}
	f.sequence(:response_cd4a_day_14){|n| "#{n}"}
	f.sequence(:response_cd5a_day_14){|n| "#{n}"}
	f.sequence(:response_cd56_day_14){|n| "#{n}"}
	f.sequence(:response_cd61_day_14){|n| "#{n}"}
	f.sequence(:response_cd7a_day_14){|n| "#{n}"}
	f.sequence(:response_cd8a_day_14){|n| "#{n}"}
	f.response_day30_is_in_remission { random_yndk() }
	f.chest_imaging_report_found	{ random_yndk() }
	f.chest_imaging_report_on { random_date() }
	f.mediastinal_mass_present { random_yndk() }
	f.sequence(:chest_imaging_comment){|n| "#{n}"}
	f.received_chest_ct { random_yndk() }
	f.chest_ct_taken_on { random_date() }
	f.chest_ct_medmass_present { random_yndk() }
#	f.sequence(:user_id){|n| n }
	f.cytogen_trisomy10 { random_yndk() }
	f.cytogen_trisomy17 { random_yndk() }
	f.cytogen_trisomy21 { random_yndk() }
	f.is_down_syndrome_phenotype { random_yndk() }
	f.cytogen_trisomy4 { random_yndk() }
	f.cytogen_trisomy5 { random_yndk() }
	f.cytogen_report_found { random_yndk() }
	f.cytogen_report_on { random_date() }
	f.sequence(:conventional_karyotype_results){|n| "#{n}"}
	f.sequence(:normal_cytogen){|n| "#{n}"}
	f.sequence(:is_cytogen_hosp_fish_t1221_done){|n| "#{n}"}
	f.sequence(:is_karyotype_normal){|n| "#{n}"}
	f.sequence(:number_normal_metaphase_karyotype){|n| n }
	f.sequence(:number_metaphase_tested_karyotype){|n| n }
	f.sequence(:cytogen_comment){|n| "#{n}"}
	f.is_verification_complete { random_true_or_false }	#[true,false][rand(2)]
	f.sequence(:discharge_summary){|n| "#{n}"}
	f.diagnosis_is_b_all { random_yndk() }
	f.diagnosis_is_t_all { random_yndk() }
	f.diagnosis_is_all { random_yndk() }
	f.sequence(:diagnosis_all_type_id){|n| n}
	f.diagnosis_is_cml { random_yndk() }
	f.diagnosis_is_cll { random_yndk() }
	f.diagnosis_is_aml { random_yndk() }
	f.sequence(:diagnosis_aml_type_id){|n| n}
	f.diagnosis_is_other { random_yndk() }
	f.flow_cyto_report_found { random_yndk() }
	f.sequence(:received_flow_cyto_day_14){|n| n }
	f.sequence(:received_flow_cyto_day_7){|n| n }
	f.flow_cyto_report_on { random_date() }
	f.response_flow_cyto_day_14_on { random_date() }
	f.response_flow_cyto_day_7_on { random_date() }
	f.sequence(:flow_cyto_cd10){|n| "#{n}"}
	f.sequence(:flow_cyto_igm){|n| "#{n}"}
	f.sequence(:flow_cyto_igm_text){|n| "#{n}"}
	f.sequence(:flow_cyto_bm_kappa){|n| "#{n}"}
	f.sequence(:flow_cyto_bm_kappa_text){|n| "#{n}"}
	f.sequence(:flow_cyto_bm_lambda){|n| "#{n}"}
	f.sequence(:flow_cyto_bm_lambda_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd10_19){|n| "#{n}"}
	f.sequence(:flow_cyto_cd10_19_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd10_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd19){|n| "#{n}"}
	f.sequence(:flow_cyto_cd19_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd20){|n| "#{n}"}
	f.sequence(:flow_cyto_cd20_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd21){|n| "#{n}"}
	f.sequence(:flow_cyto_cd21_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd22){|n| "#{n}"}
	f.sequence(:flow_cyto_cd22_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd23){|n| "#{n}"}
	f.sequence(:flow_cyto_cd23_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd24){|n| "#{n}"}
	f.sequence(:flow_cyto_cd24_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd40){|n| "#{n}"}
	f.sequence(:flow_cyto_cd40_text){|n| "#{n}"}
	f.sequence(:flow_cyto_surface_ig){|n| "#{n}"}
	f.sequence(:flow_cyto_surface_ig_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd1a){|n| "#{n}"}
	f.sequence(:flow_cyto_cd1a_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd2){|n| "#{n}"}
	f.sequence(:flow_cyto_cd2_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd3){|n| "#{n}"}
	f.sequence(:flow_cyto_cd3_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd4){|n| "#{n}"}
	f.sequence(:flow_cyto_cd4_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd5){|n| "#{n}"}
	f.sequence(:flow_cyto_cd5_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd7){|n| "#{n}"}
	f.sequence(:flow_cyto_cd7_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd8){|n| "#{n}"}
	f.sequence(:flow_cyto_cd8_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd3_cd4){|n| "#{n}"}
	f.sequence(:flow_cyto_cd3_cd4_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd3_cd8){|n| "#{n}"}
	f.sequence(:flow_cyto_cd3_cd8_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd11b){|n| "#{n}"}
	f.sequence(:flow_cyto_cd11b_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd11c){|n| "#{n}"}
	f.sequence(:flow_cyto_cd11c_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd13){|n| "#{n}"}
	f.sequence(:flow_cyto_cd13_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd15){|n| "#{n}"}
	f.sequence(:flow_cyto_cd15_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd33){|n| "#{n}"}
	f.sequence(:flow_cyto_cd33_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd41){|n| "#{n}"}
	f.sequence(:flow_cyto_cd41_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cdw65){|n| "#{n}"}
	f.sequence(:flow_cyto_cdw65_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd34){|n| "#{n}"}
	f.sequence(:flow_cyto_cd34_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd61){|n| "#{n}"}
	f.sequence(:flow_cyto_cd61_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd14){|n| "#{n}"}
	f.sequence(:flow_cyto_cd14_text){|n| "#{n}"}
	f.sequence(:flow_cyto_glycoa){|n| "#{n}"}
	f.sequence(:flow_cyto_glycoa_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd16){|n| "#{n}"}
	f.sequence(:flow_cyto_cd16_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd56){|n| "#{n}"}
	f.sequence(:flow_cyto_cd56_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd57){|n| "#{n}"}
	f.sequence(:flow_cyto_cd57_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd9){|n| "#{n}"}
	f.sequence(:flow_cyto_cd9_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd25){|n| "#{n}"}
	f.sequence(:flow_cyto_cd25_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd38){|n| "#{n}"}
	f.sequence(:flow_cyto_cd38_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd45){|n| "#{n}"}
	f.sequence(:flow_cyto_cd45_text){|n| "#{n}"}
	f.sequence(:flow_cyto_cd71){|n| "#{n}"}
	f.sequence(:flow_cyto_cd71_text){|n| "#{n}"}
	f.sequence(:flow_cyto_tdt){|n| "#{n}"}
	f.sequence(:flow_cyto_tdt_text){|n| "#{n}"}
	f.sequence(:flow_cyto_hladr){|n| "#{n}"}
	f.sequence(:flow_cyto_hladr_text){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_1_name){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_1){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_1_text){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_2_name){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_2){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_2_text){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_3_name){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_3){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_3_text){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_4_name){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_4){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_4_text){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_5_name){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_5){|n| "#{n}"}
	f.sequence(:flow_cyto_other_marker_5_text){|n| "#{n}"}
	f.sequence(:flow_cyto_remarks){|n| "#{n}"}
	f.tdt_often_found_flow_cytometry { random_yndk() }
	f.tdt_report_found { random_yndk() }
	f.tdt_report_on { random_date() }
	f.tdt_positive_or_negative { random_pos_neg() }
	f.sequence(:tdt_numerical_result){|n| n }
	f.tdt_found_in_flow_cyto_chart { random_true_or_false }	#[true,false][rand(2)]
	f.tdt_found_in_separate_report { random_true_or_false }	#[true,false][rand(2)]
	f.sequence(:response_comment_day_7){|n| "#{n}"}
	f.sequence(:response_comment_day_14){|n| "#{n}"}
	f.cytogen_karyotype_done { random_yndk() }
	f.cytogen_hospital_fish_done { random_yndk() }
	f.sequence(:hospital_fish_results){|n| "#{n}"}
	f.cytogen_ucb_fish_done { random_yndk() }
	f.sequence(:ucb_fish_results){|n| "#{n}"}
	f.sequence(:response_hladr_day_14){|n| "#{n}"}
	f.sequence(:response_hladr_day_7){|n| "#{n}"}
	f.histo_report_found { random_yndk() }
	f.histo_report_on { random_date() }
	f.sequence(:histo_report_results){|n| "#{n}"}
	f.diagnosed_on { random_date() }
	f.treatment_began_on { random_date() }
	f.response_is_inconclusive_day_14 { random_yndk() }
	f.response_is_inconclusive_day_21 { random_yndk() }
	f.response_is_inconclusive_day_28 { random_yndk() }
	f.response_is_inconclusive_day_7 { random_yndk() }
	f.sequence(:abstractor_id){|n| n }
	f.abstracted_on { random_date() }
	f.sequence(:reviewer_id){|n| n }
	f.reviewed_on { random_date() }
	f.data_entry_done_on { random_date() }
#	f.sequence(:abstract_version_number){|n| n }
	f.flow_cyto_num_results_available { random_yndk() }
	f.sequence(:response_other1_value_day_14){|n| "#{n}"}
	f.sequence(:response_other1_value_day_7){|n| "#{n}"}
	f.sequence(:response_other2_value_day_14){|n| "#{n}"}
	f.sequence(:response_other2_value_day_7){|n| "#{n}"}
	f.sequence(:response_other3_value_day_14){|n| "#{n}"}
	f.sequence(:response_other4_value_day_14){|n| "#{n}"}
	f.sequence(:response_other5_value_day_14){|n| "#{n}"}
	f.h_and_p_reports_found { random_yndk() }
	f.is_h_and_p_report_found { random_true_or_false }	#[true,false][rand(2)]
	f.h_and_p_reports_on { random_date() }
	f.sequence(:physical_neuro){|n| "#{n}"}
	f.sequence(:physical_other_soft_2){|n| "#{n}"}
	f.sequence(:vital_status_id){|n| n }
	f.dod  { random_date() }
	f.discharge_summary_found { random_yndk() }
	f.sequence(:physical_gingival){|n| "#{n}"}
	f.sequence(:physical_leukemic_skin){|n| "#{n}"}
	f.sequence(:physical_lymph){|n| "#{n}"}
	f.sequence(:physical_spleen){|n| "#{n}"}
	f.sequence(:physical_testicle){|n| "#{n}"}
	f.sequence(:physical_other_soft){|n| "#{n}"}
	f.ploidy_report_found { random_yndk() }
	f.ploidy_report_on { random_date() }
	f.sequence(:is_hypodiploid){|n| "#{n}"}
	f.sequence(:is_hyperdiploid){|n| "#{n}"}
	f.sequence(:is_diploid){|n| "#{n}"}
	f.sequence(:dna_index){|n| "#{n}"}
	f.sequence(:other_dna_measure){|n| "#{n}"}
	f.sequence(:ploidy_comment){|n| "#{n}"}
	f.sequence(:hepatomegaly_present){|n| n }
	f.sequence(:splenomegaly_present){|n| n }
	f.sequence(:response_comment){|n| "#{n}"}
	f.sequence(:response_other1_name_day_14){|n| "#{n}"}
	f.sequence(:response_other1_name_day_7){|n| "#{n}"}
	f.sequence(:response_other2_name_day_14){|n| "#{n}"}
	f.sequence(:response_other2_name_day_7){|n| "#{n}"}
	f.sequence(:response_other3_name_day_14){|n| "#{n}"}
	f.sequence(:response_other4_name_day_14){|n| "#{n}"}
	f.sequence(:response_other5_name_day_14){|n| "#{n}"}
	f.sequence(:fab_classification){|n| "#{n}"}
	f.sequence(:diagnosis_icdo_description){|n| "#{n}"}
	f.sequence(:diagnosis_icdo_number){|n| "#{n}"}
	f.sequence(:cytogen_t1221){|n| "#{n}"}
	f.sequence(:cytogen_inv16){|n| "#{n}"}
	f.sequence(:cytogen_t119){|n| "#{n}"}
	f.sequence(:cytogen_t821){|n| "#{n}"}
	f.sequence(:cytogen_t1517){|n| "#{n}"}
	f.sequence(:cytogen_is_hyperdiploidy){|n| "#{n}"}
	f.sequence(:cytogen_chromosome_number){|n| "#{n}"}
	f.sequence(:cytogen_t922){|n| "#{n}"}
	f.sequence(:cytogen_other_trans_1){|n| "#{n}"}
	f.sequence(:cytogen_other_trans_2){|n| "#{n}"}
	f.sequence(:cytogen_other_trans_3){|n| "#{n}"}
	f.sequence(:cytogen_other_trans_4){|n| "#{n}"}
	f.sequence(:cytogen_other_trans_5){|n| "#{n}"}
	f.sequence(:cytogen_other_trans_6){|n| "#{n}"}
	f.sequence(:cytogen_other_trans_7){|n| "#{n}"}
	f.sequence(:cytogen_other_trans_8){|n| "#{n}"}
	f.sequence(:cytogen_other_trans_9){|n| "#{n}"}
	f.sequence(:cytogen_other_trans_10){|n| "#{n}"}
	f.sequence(:response_fab_subtype){|n| "#{n}"}
	f.sequence(:response_tdt_day_14){|n| "#{n}"}
	f.sequence(:response_tdt_day_7){|n| "#{n}"}
#	f.sequence(:abstract_version_description){|n| "#{n}"}
	f.sequence(:abstract_version_id){|n| n }
	f.height_at_diagnosis { random_float() }
	f.weight_at_diagnosis { random_float() }
end
