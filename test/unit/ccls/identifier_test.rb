require 'test_helper'

class Ccls::IdentifierTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_many(:interviews)

	assert_should_not_require_attributes( :study_subject_id )

#	assert_should_initially_belong_to(:subject)

#	assert_requires_valid_association( :subject, :as => 'study_subject' )

	assert_should_require_attributes( :case_control_type )
	assert_should_require_attributes( :childid )
	assert_should_require_attributes( :orderno )
	assert_should_require_attributes( :patid )
#	assert_should_require_attributes( :ssn )
	assert_should_not_require_attributes( :ssn )
#	assert_should_require_attributes( :subjectid )
	assert_should_not_require_attributes( :subjectid )
#	assert_should_require_attributes( :study_subject_id )
	assert_should_require_unique_attributes( :childid )
	assert_should_require_unique_attributes( :ssn )
#	assert_should_require_unique_attributes( :study_subject_id )
	assert_should_require_unique_attributes( :subjectid )
	assert_should_require_unique_attribute( :patid, 
		:scope => [:orderno,:case_control_type] )
	assert_should_not_require_attributes( :lab_no )
	assert_should_not_require_attributes( :related_childid )
	assert_should_not_require_attributes( :related_case_childid )
	assert_should_not_require_attributes( :hospital_no )
#	assert_should_require_attributes( :state_id_no )
	assert_should_not_require_attributes( :state_id_no )
	assert_should_require_unique_attributes( :state_id_no )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :state_id_no )
		o.assert_should_require_attribute_length( :case_control_type )
		o.assert_should_require_attribute_length( :lab_no )
		o.assert_should_require_attribute_length( :related_childid )
		o.assert_should_require_attribute_length( :related_case_childid )
	end
	assert_should_not_require_attributes( :matchingid )
	assert_should_not_require_attributes( :familyid )

	assert_should_require_attribute_length :childidwho, :maximum => 10
	assert_should_require_attribute_length :newid, :maximum => 6
	assert_should_require_attribute_length :gbid, :maximum => 26
	assert_should_require_attribute_length :lab_no_wiemels, :maximum => 25
	assert_should_require_attribute_length :idno_wiemels, :maximum => 10
	assert_should_require_attribute_length :accession_no, :maximum => 25
	assert_should_require_attribute_length :icf_master_id, :maximum => 9

#	computed fields so won't test correctly like this
#	assert_should_require_attribute_length :studyid, :maximum => 14
#	assert_should_require_attribute_length :studyid_nohyphen, :maximum => 12
#	assert_should_require_attribute_length :studyid_intonly_nohyphen, :maximum => 12


#	assert_should_protect_attributes(:subjectid)

	#
	#	subject uses accepts_attributes_for :pii
	#	so the pii can't require subject_id on create
	#	or this test fails.
	#
	test "should require study_subject_id on update" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object
			object.reload.update_attributes(:orderno => "New Order No")
			assert object.errors.on(:subject)
		end
	end

	test "should require unique study_subject_id" do
		subject = Factory(:subject)
		create_object(:subject => subject)
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:subject => subject)
			assert object.errors.on(:study_subject_id)
		end
	end



	test "should pad subjectid with leading zeros" do
		identifier = Factory.build(:identifier)
		assert identifier.subjectid.length < 6 
		identifier.save
		assert identifier.subjectid.length == 6
	end 

	test "should pad matchingid with leading zeros" do
		identifier = Factory.build(:identifier,{ :matchingid => '123' })
		assert identifier.matchingid.length < 6 
		assert_equal '123', identifier.matchingid
		identifier.save
		assert identifier.matchingid.length == 6
		assert_equal '000123', identifier.matchingid
	end 

	test "should create with all numeric ssn" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:ssn => 987654321)
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal '987654321', object.reload.ssn
		end
	end

	test "should create with string all numeric ssn" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:ssn => '987654321')
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal '987654321', object.reload.ssn
		end
	end

	test "should create with string standard format ssn" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:ssn => '987-65-4321')
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
			assert_equal '987654321', object.reload.ssn
		end
	end

	test "should require 9 digits in ssn" do
pending
#		%w( 12345678X 12345678 1-34-56-789 ).each do |invalid_ssn|
#			assert_difference( "#{model_name}.count", 0 ) do
#				object = create_object(:ssn => invalid_ssn)
#				assert object.errors.on(:ssn)
#			end
#		end
	end

protected

	def create_object(options={})
		record = Factory.build(:identifier,options)
		record.attributes=options
		record.save
		record
	end

end
