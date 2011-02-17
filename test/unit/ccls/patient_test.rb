require 'test_helper'

class Ccls::PatientTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:subject)
	assert_should_belong_to( :organization )
	assert_should_belong_to( :diagnosis )
	assert_should_require_attributes( :study_subject_id )
	assert_should_require_unique_attributes( :study_subject_id )
	assert_should_not_require_attributes( :admit_date )
	assert_should_not_require_attributes( :diagnosis_date )
	assert_should_not_require_attributes( :hospital_no )
	assert_should_not_require_attributes( :diagnosis_id )
	assert_should_not_require_attributes( :organization_id )

	assert_requires_valid_association( :subject, :as => 'study_subject' )

	assert_requires_complete_date(:admit_date)
	assert_requires_past_date(:admit_date)
	assert_requires_complete_date(:diagnosis_date)
	assert_requires_past_date(:diagnosis_date)

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

end
