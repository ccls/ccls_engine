require 'test_helper'

class Ccls::PatientTest < ActiveSupport::TestCase

	[ :was_under_15_at_dx, :was_previously_treated,
		:was_ca_resident_at_diagnosis ].each do |field|

		#	Making assumption that 12345 will NEVER be a valid value.
		test "should NOT allow 12345 for #{field}" do
			patient = Patient.new(field => 12345)
			patient.valid?
			assert patient.errors.on_attr_and_type?(field,:inclusion)
		end

		test "should allow nil for #{field}" do
			patient = Patient.new(field => nil)
			assert_nil patient.send(field)
			patient.valid?
			assert !patient.errors.on(field)
		end

		test "should allow all valid YNDK values for #{field}" do
			patient = Patient.new
			YNDK.valid_values.each do |value|
				patient.send("#{field}=", value)
				patient.valid?
				assert !patient.errors.on(field)
			end
		end

	end

	assert_should_create_default_object
	assert_should_initially_belong_to :study_subject
	assert_should_initially_belong_to :organization
	assert_should_initially_belong_to :diagnosis
	assert_should_protect( :study_subject_id, :study_subject )

	assert_should_require_attributes(
		:diagnosis_id,
		:hospital_no, :organization_id, :admit_date )

	assert_should_not_require_attributes(
		:other_diagnosis,
		:diagnosis_date,
		:raf_zip,
		:raf_county )

	assert_should_require_attribute_length :hospital_no, :maximum => 25
	assert_should_require_unique(:hospital_no, :scope => :organization_id)
	assert_should_require_attribute_length( :raf_zip, :maximum => 10 )
	assert_requires_complete_date :admit_date
	assert_requires_complete_date :diagnosis_date
	assert_requires_complete_date :treatment_began_on
	assert_requires_past_date :admit_date
	assert_requires_past_date :diagnosis_date
	assert_requires_past_date :treatment_began_on

	test "explicit Factory subjectless patient test" do
		assert_difference('StudySubject.count',0) {
		assert_difference('Patient.count',1) {
			patient = Factory(:subjectless_patient)
			assert_nil patient.study_subject
			assert_not_nil patient.admit_date
			assert_not_nil patient.hospital_no
			assert_not_nil patient.organization_id
			assert_not_nil patient.diagnosis_id
		} }
	end

	test "explicit Factory patient hospital sequence test" do
		patient = Factory(:patient)		#	'first' hospital
		(Hospital.count - 1).times {	#	loop over the rest of the hospitals
			new_patient = Factory(:patient)
			assert patient.organization_id != new_patient.organization_id
		}
		new_patient = Factory(:patient)	#	back to the 'first' hospital
		assert patient.organization_id == new_patient.organization_id
	end

	test "explicit Factory patient test" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Patient.count',1) {
			patient = Factory(:patient)
			assert_not_nil patient.study_subject
			assert_equal patient.study_subject.subject_type, SubjectType['Case']
		} }
	end

	test "explicit Factory waivered patient hospital sequence test" do
		patient = Factory(:waivered_patient)		#	'first' hospital
		(Hospital.waivered.count - 1).times {	#	loop over the rest of the hospitals
			new_patient = Factory(:waivered_patient)
			assert patient.organization_id != new_patient.organization_id
		}
		new_patient = Factory(:waivered_patient)	#	back to the 'first' hospital
		assert patient.organization_id == new_patient.organization_id
	end

	test "explicit Factory waivered_patient test" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Patient.count',1) {
			patient = Factory(:waivered_patient)
			assert_not_nil patient.study_subject
			assert_equal patient.study_subject.subject_type, SubjectType['Case']
			assert patient.organization.hospital.has_irb_waiver
		} }
	end

	test "explicit Factory nonwaivered patient hospital sequence test" do
		patient = Factory(:nonwaivered_patient)		#	'first' hospital
		(Hospital.nonwaivered.count - 1).times {	#	loop over the rest of the hospitals
			new_patient = Factory(:nonwaivered_patient)
			assert patient.organization_id != new_patient.organization_id
		}
		new_patient = Factory(:nonwaivered_patient)	#	back to the 'first' hospital
		assert patient.organization_id == new_patient.organization_id
	end

	test "explicit Factory nonwaivered_patient test" do
		assert_difference('StudySubject.count',1) {
		assert_difference('Patient.count',1) {
			patient = Factory(:nonwaivered_patient)
			assert_not_nil patient.study_subject
			assert_equal patient.study_subject.subject_type, SubjectType['Case']
			assert !patient.organization.hospital.has_irb_waiver
		} }
	end

	test "should default was_ca_resident_at_diagnosis to null" do
		assert_difference( "Patient.count", 1 ) {
			patient = create_patient
			assert_nil patient.reload.was_ca_resident_at_diagnosis
		}
	end

	test "should default was_previously_treated to null" do
		assert_difference( "Patient.count", 1 ) {
			patient = create_patient
			assert_nil patient.reload.was_previously_treated
		}
	end

#	This would have been because there was no dob because
#	there was no pii.  Not true anymore
#	test "should default was_under_15_at_dx to null" do
#		assert_difference( "Patient.count", 1 ) {
#			patient = create_patient
#			assert_nil patient.reload.was_under_15_at_dx
#		}
#	end

	test "should require Case study_subject" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "Patient.count", 0 ) {
			patient = create_patient(:study_subject => Factory(:study_subject))
			assert patient.errors.on(:study_subject)
		} }
	end

	test "should require case study_subject when using nested attributes" do
		assert_difference( "StudySubject.count", 0 ) {
		assert_difference( "Patient.count", 0 ) {
			study_subject = create_study_subject(
				:patient_attributes => Factory.attributes_for(:patient))
			#	raised from study_subject model, NOT patient
			assert study_subject.errors.on(:patient)
		} }
	end

	test "should allow admit_date be on DOB" do
		assert_difference( "Patient.count", 1 ) {
			study_subject = Factory(:case_study_subject)
			patient = create_patient(
				:study_subject => study_subject,
				:admit_date => study_subject.dob )
			assert !patient.errors.on(:admit_date)
			assert_equal study_subject.dob, patient.admit_date
		}
	end

	test "should require admit_date be after DOB" do
		assert_difference( "Patient.count", 0 ) {
			study_subject = Factory(:case_study_subject)
			assert Date.jd(2430000) < study_subject.dob
			patient = create_patient(
				:study_subject => study_subject,
				:admit_date => Date.jd(2430000) ) 
				# BEFORE my factory set dob to raise error (Date.jd(2440000+rand(15000))
			assert patient.errors.on(:admit_date)
			assert_match(/before.*dob/,
				patient.errors.on(:admit_date))
		}
	end

	test "should NOT require admit_date 1/1/1900 be after DOB" do
		assert_difference( "Patient.count", 1 ) {
			study_subject = Factory(:case_study_subject)
			patient = create_patient(
				:study_subject => study_subject,
				:admit_date => Date.parse('1/1/1900') )
			assert !patient.errors.on(:admit_date)
		}
	end

	test "should require admit_date be after DOB when using nested attributes" do
		assert_difference( "StudySubject.count", 0 ) {
		assert_difference( "Patient.count", 0 ) {
			study_subject = create_case_study_subject(
				:patient_attributes => Factory.attributes_for(:patient,{
					# BEFORE my factory set dob to raise error (Date.jd(2440000+rand(15000))
					:admit_date => Date.jd(2430000)
				}))
			assert study_subject.errors.on('patient:admit_date')
			assert_match(/before.*dob/,
				study_subject.errors.on('patient:admit_date'))
		} }
	end

	test "should NOT require admit_date 1/1/1900 be after DOB" <<
			" when using nested attributes" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			study_subject = create_case_study_subject(
				:patient_attributes => Factory.attributes_for(:patient,{
					:admit_date => Date.parse('1/1/1900')
				}))
			assert !study_subject.errors.on('patient:admit_date')
		} }
	end


	test "should allow diagnosis_date be on DOB" do
		assert_difference( "Patient.count", 1 ) do
			study_subject = Factory(:case_study_subject)
			patient = create_patient(
				:study_subject => study_subject,
				:diagnosis_date => study_subject.dob )
			assert !patient.errors.on(:diagnosis_date)
			assert_equal patient.diagnosis_date, study_subject.dob
		end
	end

	test "should require diagnosis_date be after DOB" do
		assert_difference( "Patient.count", 0 ) do
			study_subject = Factory(:case_study_subject)
			assert Date.jd(2430000) < study_subject.dob
			patient = create_patient(
				:study_subject => study_subject,
				:diagnosis_date => Date.jd(2430000) ) 
				# BEFORE my factory set dob to raise error (Date.jd(2440000+rand(15000))
			assert patient.errors.on(:diagnosis_date)
			assert_match(/before.*dob/,
				patient.errors.on(:diagnosis_date))
		end
	end

	test "should require diagnosis_date be after DOB when using nested attributes" do
		assert_difference( "StudySubject.count", 0 ) {
		assert_difference( "Patient.count", 0 ) {
			study_subject = create_case_study_subject(
				:patient_attributes => Factory.attributes_for(:patient,{
					# BEFORE my factory set dob to raise error
					:diagnosis_date => Date.jd(2430000),
				}))
			assert study_subject.errors.on('patient:diagnosis_date')
		} }
	end


	test "should require treatment_began_on be after diagnosis_date" do
		assert_difference( "Patient.count", 0 ) do
			study_subject = Factory(:case_study_subject,
				:dob => Date.jd(2420000) )
			patient = create_patient(
				:study_subject => study_subject,
				:diagnosis_date => Date.jd(2440000),
				:treatment_began_on => Date.jd(2430000) ) 
			assert patient.errors.on(:treatment_began_on)
			assert_match(/Date treatment began must be on or after the diagnosis date/,
				patient.errors.on(:treatment_began_on))
		end
	end

	test "should require treatment_began_on be after diagnosis_date" <<
			" when using nested attributes" do
		assert_difference( "StudySubject.count", 0 ) {
		assert_difference( "Patient.count", 0 ) {
			study_subject = create_case_study_subject(
				:dob => Date.jd(2420000),
				:patient_attributes => Factory.attributes_for(:patient,{
					:diagnosis_date => Date.jd(2440000),
					:treatment_began_on => Date.jd(2430000),
				}))
			assert study_subject.patient.errors.on(:treatment_began_on)
			assert study_subject.errors.on('patient.treatment_began_on')
			assert_match(/Date treatment began must be on or after the diagnosis date/,
				study_subject.patient.errors.on(:treatment_began_on))
		} }
	end


	test "should NOT set was_under_15_at_dx with admit_date 1/1/1900" <<
			" using nested attributes" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			dob        = 10.years.ago.to_date
			admit_date = Date.parse('1/1/1900')
			study_subject = create_case_study_subject(
				:dob => dob,
				:patient_attributes => Factory.attributes_for(:patient,{
					:admit_date => admit_date
				})
			).reload
			assert_equal dob,        study_subject.dob
			assert_equal admit_date, study_subject.patient.admit_date
			assert_nil study_subject.patient.was_under_15_at_dx
		} }
	end

	test "should NOT set was_under_15_at_dx with admit_date 1/1/1900" <<
			" not using nested attributes" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			dob        = 10.years.ago.to_date
			admit_date = Date.parse('1/1/1900')
			study_subject = create_case_study_subject( :dob => dob )
			patient = Factory(:patient,{
				:study_subject => study_subject,
				:admit_date => admit_date
			})
			study_subject.reload
			assert_equal dob,        study_subject.dob
			assert_equal admit_date, study_subject.patient.admit_date
			assert_nil study_subject.patient.was_under_15_at_dx
		} }
	end


	test "should NOT set was_under_15_at_dx with dob 1/1/1900 using nested attributes" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			dob        = Date.parse('1/1/1900')
			admit_date = 1.year.ago.to_date
			study_subject = create_case_study_subject(
				:dob => dob,
				:patient_attributes => Factory.attributes_for(:patient,{
					:admit_date => admit_date
				})
			).reload
			assert_equal dob,        study_subject.dob
			assert_equal admit_date, study_subject.patient.admit_date
			assert_nil study_subject.patient.was_under_15_at_dx
		} }
	end

	test "should NOT set was_under_15_at_dx with dob 1/1/1900 not using nested attributes" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			dob        = Date.parse('1/1/1900')
			admit_date = 1.year.ago.to_date
			study_subject = create_case_study_subject( :dob => dob )
			patient = Factory(:patient,{
				:study_subject => study_subject,
				:admit_date => admit_date
			})
			study_subject.reload
			assert_equal dob,        study_subject.dob
			assert_equal admit_date, study_subject.patient.admit_date
			assert_nil study_subject.patient.was_under_15_at_dx
		} }
	end


	test "should set was_under_15_at_dx to YNDK[:yes] using nested attributes" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			dob        = 14.years.ago.to_date
			admit_date = 1.year.ago.to_date
			study_subject = create_case_study_subject(
				:dob => dob,
				:patient_attributes => Factory.attributes_for(:patient,{
					:admit_date => admit_date
				})
			).reload
			assert_equal dob,        study_subject.dob
			assert_equal admit_date, study_subject.patient.admit_date
			assert_equal YNDK[:yes], study_subject.patient.was_under_15_at_dx
		} }
	end

	test "should set was_under_15_at_dx to YNDK[:yes] not using nested attributes" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			dob        = 14.years.ago.to_date
			admit_date = 1.year.ago.to_date
			study_subject = create_case_study_subject( :dob => dob )
			patient = Factory(:patient,{
				:study_subject => study_subject,
				:admit_date => admit_date
			})
			study_subject.reload
			assert_equal dob,        study_subject.dob
			assert_equal admit_date, study_subject.patient.admit_date
			assert_equal YNDK[:yes], study_subject.patient.was_under_15_at_dx
		} }
	end


	test "should set was_under_15_at_dx to YNDK[:no] using nested attributes" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			dob        = 20.years.ago.to_date
			admit_date = 1.year.ago.to_date
			study_subject = create_case_study_subject(
				:dob => dob,
				:patient_attributes => Factory.attributes_for(:patient,{
					:admit_date => admit_date
				})
			).reload
			assert_equal dob,        study_subject.dob
			assert_equal admit_date, study_subject.patient.admit_date
			assert_equal YNDK[:no], study_subject.patient.was_under_15_at_dx
		} }
	end

	test "should set was_under_15_at_dx to YNDK[:no] not using nested attributes" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			dob        = 20.years.ago.to_date
			admit_date = 1.year.ago.to_date
			study_subject = create_case_study_subject( :dob => dob )
			#	patient creation MUST come AFTER pii creation
			patient = Factory(:patient,{
				:study_subject    => study_subject,
				:admit_date => admit_date
			})
			study_subject.reload
			assert_equal dob,        study_subject.dob
			assert_equal admit_date, study_subject.patient.admit_date
			assert_equal YNDK[:no], study_subject.patient.was_under_15_at_dx
		} }
	end

	test "should set was_under_15_at_dx on dob change" do
		study_subject = create_case_study_subject(
			:dob => 20.years.ago.to_date,
			:patient_attributes => Factory.attributes_for(:patient,{
				:admit_date => 1.year.ago.to_date
			})
		).reload
		assert_equal YNDK[:no], study_subject.patient.was_under_15_at_dx
		study_subject.update_attributes(:dob => 10.years.ago.to_date)
		assert_equal YNDK[:yes], study_subject.patient.reload.was_under_15_at_dx
	end

	test "should set was_under_15_at_dx on admit_date change" do
		study_subject = create_case_study_subject(
			:dob => 20.years.ago.to_date,
			:patient_attributes => Factory.attributes_for(:patient,{
				:admit_date => 1.year.ago.to_date
			})
		).reload
		assert_equal YNDK[:no], study_subject.patient.was_under_15_at_dx
		study_subject.patient.update_attributes(:admit_date => 10.years.ago.to_date)
		assert_equal YNDK[:yes], study_subject.patient.reload.was_under_15_at_dx
	end

	test "should require 5 or 9 digit raf_zip" do
		%w( asdf 1234 123456 1234Q ).each do |bad_zip|
			assert_difference( "Patient.count", 0 ) do
				patient = create_patient( :raf_zip => bad_zip )
				assert patient.errors.on(:raf_zip)
			end
		end
		%w( 12345 12345-6789 123456789 ).each do |good_zip|
			assert_difference( "Patient.count", 1 ) do
				patient = create_patient( :raf_zip => good_zip )
				assert !patient.errors.on(:raf_zip)
				assert patient.raf_zip =~ /\A\d{5}(-)?(\d{4})?\z/
			end
		end
	end

	test "should format 9 digit zip" do
		assert_difference( "Patient.count", 1 ) do
			patient = create_patient( :raf_zip => '123456789' )
			assert !patient.errors.on(:raf_zip)
			assert patient.raf_zip =~ /\A\d{5}(-)?(\d{4})?\z/
			assert_equal '12345-6789', patient.raf_zip
		end
	end

	test "should require other_diagnosis if diagnosis == other" do
		assert_difference( "Patient.count", 0 ) do
			patient = create_patient(:diagnosis => Diagnosis['other'])
			assert patient.errors.on_attr_and_type?(:other_diagnosis,:blank)
		end
	end

	test "should not require other_diagnosis if diagnosis != other" do
		assert_difference( "Patient.count", 1 ) do
			patient = create_patient(:diagnosis => Diagnosis['ALL'])
			assert !patient.errors.on_attr_and_type?(:other_diagnosis,:blank)
		end
	end

	test "should require hospital_no with custom message" do
		assert_difference( "Patient.count", 0 ) do
			patient = create_patient( :hospital_no => nil )
			assert patient.errors.on_attr_and_type?(:hospital_no,:blank)
			assert_match /Hospital record number can't be blank/, 
				patient.errors.full_messages.to_sentence
			assert_no_match /Hospital no/i, 
				patient.errors.full_messages.to_sentence
		end
	end

	test "should require organization_id with custom message" do
		assert_difference( "Patient.count", 0 ) do
			patient = create_patient( :organization_id => nil )
			assert patient.errors.on_attr_and_type?(:organization_id,:blank)
			assert_match /Treating institution can't be blank/, 
				patient.errors.full_messages.to_sentence
			assert_no_match /Organization/i, 
				patient.errors.full_messages.to_sentence
		end
	end

#protected
#
#	def create_patient(options={})
#		patient = Factory.build(:patient,options)
#		patient.save
#		patient
#	end

end
