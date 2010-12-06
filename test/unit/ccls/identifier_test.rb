require File.dirname(__FILE__) + '/../test_helper'

class IdentifierTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_many(:interviews)
	assert_should_initially_belong_to(:subject)

	assert_requires_valid_association( :subject, :as => 'study_subject' )

	assert_should_require_attributes( :case_control_type )
	assert_should_require_attributes( :childid )
	assert_should_require_attributes( :orderno )
	assert_should_require_attributes( :patid )
	assert_should_require_attributes( :ssn )
	assert_should_require_attributes( :subjectid )
	assert_should_require_attributes( :study_subject_id )
	assert_should_require_unique_attributes( :childid )
	assert_should_require_unique_attributes( :ssn )
	assert_should_require_unique_attributes( :study_subject_id )
	assert_should_require_unique_attributes( :subjectid )
	assert_should_require_unique_attribute( :patid, 
		:scope => [:orderno,:case_control_type] )
	assert_should_not_require_attributes( :lab_no )
	assert_should_not_require_attributes( :related_childid )
	assert_should_not_require_attributes( :related_case_childid )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :case_control_type )
		o.assert_should_require_attribute_length( :lab_no )
		o.assert_should_require_attribute_length( :related_childid )
		o.assert_should_require_attribute_length( :related_case_childid )
	end


#	assert_should_protect_attributes(:subjectid)

	test "should pad subjectid with leading zeros" do
		identifier = Factory.build(:identifier)
		assert identifier.subjectid.length < 6 
		identifier.save
		assert identifier.subjectid.length == 6
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
		%w( 12345678X 12345678 1-34-56-789 ).each do |invalid_ssn|
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:ssn => invalid_ssn)
				assert object.errors.on(:ssn)
			end
		end
	end


	def create_object(options={})
		record = Factory.build(:identifier,options)
		record.attributes=options
		record.save
		record
	end

end
