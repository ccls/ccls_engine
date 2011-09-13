require 'test_helper'

class Ccls::PatientTest < ActiveSupport::TestCase

	assert_should_create_default_object

#	assert_should_belong_to(:study_subject)
	assert_should_initially_belong_to(:study_subject)
	assert_should_protect( :study_subject_id )



#	NOTE Used to work, but after changing Subject to StudySubject doesn't?  Should it?
#	assert_should_not_require_attributes( :study_subject_id )



#	assert_should_require_attributes( :study_subject_id )
#	assert_should_require_unique_attributes( :study_subject_id )

	assert_should_belong_to( :organization, :diagnosis )

	assert_should_not_require_attributes( :admit_date, :diagnosis_date,
		:diagnosis_id, :organization_id, :raf_zip, :raf_county )
	assert_should_require_attribute_length( :raf_zip, :maximum => 10 )

	assert_requires_complete_date( :admit_date, :diagnosis_date )
	assert_requires_past_date( :admit_date, :diagnosis_date )

	#
	#	study_subject uses accepts_attributes_for :patient
	#	so the patient can't require study_subject_id on create
	#	or this test fails.
	#
#	test "should require study_subject_id on update" do
#		assert_difference( "#{model_name}.count", 1 ) do
#				object = create_object
#			object.reload.update_attributes(:diagnosis_date => Date.today)
#			assert object.errors.on_attr_and_type(:study_subject,:blank)
#		end
#	end

	test "should require study_subject_id" do
		assert_difference( "StudySubject.count", 0 ) {
		assert_difference( "#{model_name}.count", 0 ) {
				object = create_object(:study_subject => nil)
			assert object.errors.on_attr_and_type(:study_subject_id, :blank)
		} }
	end

	test "should require unique study_subject_id" do
		study_subject = Factory(:case_subject)
		create_object(:study_subject => study_subject)
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:study_subject => study_subject)
			assert object.errors.on_attr_and_type(:study_subject_id,:taken)
		end
	end

	test "should require Case subject" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "#{model_name}.count", 0 ) {
			object = create_object(:study_subject => Factory(:study_subject))
			assert object.errors.on(:study_subject)
		} }
	end

	test "should require case subject when using nested attributes" do
		assert_difference( "StudySubject.count", 0 ) {
		assert_difference( "#{model_name}.count", 0 ) {
			study_subject = create_study_subject(
				:patient_attributes => Factory.attributes_for(:patient))
			assert study_subject.errors.on(:patient)	#	raised from study_subject model, NOT patient
		} }
	end

	test "should require admit_date be after DOB" do
		assert_difference( "#{model_name}.count", 0 ) do
			study_subject = Factory(:case_subject)
			pii = Factory(:pii,:study_subject => study_subject)
			object = create_object(
				:study_subject => study_subject,
				:admit_date => Date.jd(2430000) ) 
				# smaller than my factory set dob
			assert object.errors.on(:admit_date)
			assert_match(/before.*dob/,
				object.errors.on(:admit_date))
		end
	end

	test "should require admit_date be after DOB when using nested attributes" do
		assert_difference( "Pii.count", 0 ) {
		assert_difference( "StudySubject.count", 0 ) {
		assert_difference( "#{model_name}.count", 0 ) {
			study_subject = create_case_subject(
				:pii_attributes => Factory.attributes_for(:pii),
				:patient_attributes => Factory.attributes_for(:patient,{
					# smaller than my factory set dob
					:admit_date => Date.jd(2430000),
				}))
			assert study_subject.errors.on('patient:admit_date')
		} } }
	end

	test "should require diagnosis_date be after DOB" do
		assert_difference( "#{model_name}.count", 0 ) do
			study_subject = Factory(:case_subject)
			pii = Factory(:pii,:study_subject => study_subject)
			object = create_object(
				:study_subject => study_subject,
				:diagnosis_date => Date.jd(2430000) ) 
				# smaller than my factory set dob
			assert object.errors.on(:diagnosis_date)
			assert_match(/before.*dob/,
				object.errors.on(:diagnosis_date))
		end
	end

	test "should require diagnosis_date be after DOB when using nested attributes" do
		assert_difference( "Pii.count", 0 ) {
		assert_difference( "StudySubject.count", 0 ) {
		assert_difference( "#{model_name}.count", 0 ) {
			study_subject = create_case_subject(
				:pii_attributes => Factory.attributes_for(:pii),
				:patient_attributes => Factory.attributes_for(:patient,{
					# smaller than my factory set dob
					:diagnosis_date => Date.jd(2430000),
				}))
			assert study_subject.errors.on('patient:diagnosis_date')
		} } }
	end


	test "should set was_under_15_at_dx to true using nested attributes" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "Pii.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			dob        = 14.years.ago.to_date
			admit_date = 1.year.ago.to_date
			study_subject = create_case_subject(
				:pii_attributes     => Factory.attributes_for(:pii,{
					:dob => dob
				}),
				:patient_attributes => Factory.attributes_for(:patient,{
					:admit_date => admit_date
				})
			).reload
			assert_equal dob,        study_subject.pii.dob
			assert_equal admit_date, study_subject.patient.admit_date
			#
			#	this is actually the default so I'm not really testing 
			#	anything other than it wasn't explicitly set to false
			#
			assert study_subject.patient.was_under_15_at_dx
		} } }
	end

	test "should set was_under_15_at_dx to false using nested attributes" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "Pii.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			dob        = 20.years.ago.to_date
			admit_date = 1.year.ago.to_date
			study_subject = create_case_subject(
				:pii_attributes     => Factory.attributes_for(:pii,{
					:dob => dob
				}),
				:patient_attributes => Factory.attributes_for(:patient,{
					:admit_date => admit_date
				})
			).reload
			assert_equal dob,        study_subject.pii.dob
			assert_equal admit_date, study_subject.patient.admit_date
			assert !study_subject.patient.was_under_15_at_dx
		} } }
	end

	test "should set was_under_15_at_dx to false not using nested attributes" do
		assert_difference( "StudySubject.count", 1 ) {
		assert_difference( "Pii.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			dob        = 20.years.ago.to_date
			admit_date = 1.year.ago.to_date
			study_subject = create_case_subject
			pii     = Factory(:pii,{
				:study_subject => study_subject,
				:dob     => dob
			})
			#	patient creation MUST come AFTER pii creation
			patient = Factory(:patient,{
				:study_subject    => study_subject,
				:admit_date => admit_date
			})
			study_subject.reload
			assert_equal dob,        study_subject.pii.dob
			assert_equal admit_date, study_subject.patient.admit_date
			assert !study_subject.patient.was_under_15_at_dx
		} } }
	end

	test "should set was_under_15_at_dx on dob change" do
		study_subject = create_case_subject(
			:pii_attributes     => Factory.attributes_for(:pii,{
				:dob => 20.years.ago.to_date
			}),
			:patient_attributes => Factory.attributes_for(:patient,{
				:admit_date => 1.year.ago.to_date
			})
		).reload
		assert !study_subject.patient.was_under_15_at_dx
		study_subject.pii.update_attribute(:dob, 10.years.ago.to_date)
		assert  study_subject.patient.reload.was_under_15_at_dx
	end

	test "should set was_under_15_at_dx on admit_date change" do
		study_subject = create_case_subject(
			:pii_attributes     => Factory.attributes_for(:pii,{
				:dob => 20.years.ago.to_date
			}),
			:patient_attributes => Factory.attributes_for(:patient,{
				:admit_date => 1.year.ago.to_date
			})
		).reload
		assert !study_subject.patient.was_under_15_at_dx
		study_subject.patient.update_attribute(:admit_date, 10.years.ago.to_date)
		assert  study_subject.patient.reload.was_under_15_at_dx
	end

	test "should require 5 or 9 digit raf_zip" do
		%w( asdf 1234 123456 1234Q ).each do |bad_zip|
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object( :raf_zip => bad_zip )
				assert object.errors.on(:raf_zip)
			end
		end
		%w( 12345 12345-6789 123456789 ).each do |good_zip|
			assert_difference( "#{model_name}.count", 1 ) do
				object = create_object( :raf_zip => good_zip )
				assert !object.errors.on(:raf_zip)
				assert object.raf_zip =~ /\A\d{5}(-)?(\d{4})?\z/
			end
		end
	end

end
