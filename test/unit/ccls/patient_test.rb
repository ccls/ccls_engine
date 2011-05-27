require 'test_helper'

class Ccls::PatientTest < ActiveSupport::TestCase

	assert_should_create_default_object

	assert_should_belong_to(:subject)
	assert_should_belong_to( :organization )
	assert_should_belong_to( :diagnosis )

	assert_should_not_require_attributes( :study_subject_id )
	assert_should_not_require_attributes( :admit_date )
	assert_should_not_require_attributes( :diagnosis_date )
	assert_should_not_require_attributes( :diagnosis_id )
	assert_should_not_require_attributes( :organization_id )
	assert_should_not_require_attributes( :raf_zip )
	assert_should_not_require_attributes( :raf_county_id )

	assert_requires_complete_date(:admit_date)
	assert_requires_past_date(:admit_date)
	assert_requires_complete_date(:diagnosis_date)
	assert_requires_past_date(:diagnosis_date)

	#
	#	subject uses accepts_attributes_for :patient
	#	so the patient can't require subject_id on create
	#	or this test fails.
	#
	test "should require study_subject_id on update" do
		assert_difference( "#{model_name}.count", 1 ) do
				object = create_object
			object.reload.update_attributes(:diagnosis_date => Date.today)
			assert object.errors.on(:subject)
		end
	end

	test "should require unique study_subject_id" do
		subject = Factory(:case_subject)
		create_object(:subject => subject)
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:subject => subject)
			assert object.errors.on(:study_subject_id)
		end
	end

	test "should require Case subject" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:subject => Factory(:subject))
			assert object.errors.on(:subject)
		end
	end

	test "should require admit_date be after DOB" do
		assert_difference( "#{model_name}.count", 0 ) do
			subject = Factory(:case_subject)
			pii = Factory(:pii,:subject => subject)
			object = create_object(
				:subject => subject,
				:admit_date => Date.jd(2430000) ) 
				# smaller than my factory set dob
			assert object.errors.on(:admit_date)
			assert_match(/before.*dob/,
				object.errors.on(:admit_date))
		end
	end

	test "should require diagnosis_date be after DOB" do
		assert_difference( "#{model_name}.count", 0 ) do
			subject = Factory(:case_subject)
			pii = Factory(:pii,:subject => subject)
			object = create_object(
				:subject => subject,
				:diagnosis_date => Date.jd(2430000) ) 
				# smaller than my factory set dob
			assert object.errors.on(:diagnosis_date)
			assert_match(/before.*dob/,
				object.errors.on(:diagnosis_date))
		end
	end

	test "should update all matching subjects' reference date " <<
			"with updated admit date" do
		subject = create_hx_subject(:patient => {},
			:identifier => { :matchingid => '12345' }).reload
		other  = create_hx_subject( :identifier => { :matchingid => '12345' }).reload
		nobody = create_hx_subject( :identifier => { :matchingid => '54321' }).reload
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

	test "should set was_under_15_at_dx to true" do
		assert_difference( "Subject.count", 1 ) {
		assert_difference( "Pii.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			dob        = 14.years.ago.to_date
			admit_date = 1.year.ago.to_date
			subject = create_case_subject(
				:pii_attributes     => Factory.attributes_for(:pii,{
					:dob => dob
				}),
				:patient_attributes => Factory.attributes_for(:patient,{
					:admit_date => admit_date
				})
			).reload
			assert_equal dob,        subject.pii.dob
			assert_equal admit_date, subject.patient.admit_date
			#
			#	this is actually the default so I'm not really testing 
			#	anything other than it wasn't explicitly set to false
			#
			assert subject.patient.was_under_15_at_dx
		} } }
	end

	test "should set was_under_15_at_dx to false" do
		assert_difference( "Subject.count", 1 ) {
		assert_difference( "Pii.count", 1 ) {
		assert_difference( "Patient.count", 1 ) {
			dob        = 20.years.ago.to_date
			admit_date = 1.year.ago.to_date
			subject = create_case_subject(
				:pii_attributes     => Factory.attributes_for(:pii,{
					:dob => dob
				}),
				:patient_attributes => Factory.attributes_for(:patient,{
					:admit_date => admit_date
				})
			).reload
			assert_equal dob,        subject.pii.dob
			assert_equal admit_date, subject.patient.admit_date
			assert !subject.patient.was_under_15_at_dx
		} } }
	end

end
