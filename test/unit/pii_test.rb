require File.dirname(__FILE__) + '/../test_helper'

class PiiTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_belong_to(:subject)
	assert_should_require_attributes( :state_id_no )
	assert_should_require_attributes( :dob )
	assert_should_require_unique_attributes( :state_id_no )
	assert_should_require_unique_attributes( :email )
	assert_should_not_require_attributes( :study_subject_id )
	assert_should_not_require_attributes( :first_name )
	assert_should_not_require_attributes( :middle_name )
	assert_should_not_require_attributes( :last_name )
	assert_should_not_require_attributes( :died_on )
	assert_should_not_require_attributes( :mother_first_name )
	assert_should_not_require_attributes( :mother_middle_name )
	assert_should_not_require_attributes( :mother_maiden_name )
	assert_should_not_require_attributes( :mother_last_name )
	assert_should_not_require_attributes( :father_first_name )
	assert_should_not_require_attributes( :father_middle_name )
	assert_should_not_require_attributes( :father_last_name )
	assert_should_not_require_attributes( :email )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :first_name )
		o.assert_should_require_attribute_length( :middle_name )
		o.assert_should_require_attribute_length( :last_name )
		o.assert_should_require_attribute_length( :state_id_no )
		o.assert_should_require_attribute_length( :mother_first_name )
		o.assert_should_require_attribute_length( :mother_middle_name )
		o.assert_should_require_attribute_length( :mother_maiden_name )
		o.assert_should_require_attribute_length( :mother_last_name )
		o.assert_should_require_attribute_length( :father_first_name )
		o.assert_should_require_attribute_length( :father_middle_name )
		o.assert_should_require_attribute_length( :father_last_name )
	end

	assert_requires_complete_date( :dob )
	assert_requires_complete_date( :died_on )

	#
	#	subject uses accepts_attributes_for :pii
	#	so the pii can't require subject_id on create
	#	or this test fails.
	#
	test "should require study_subject_id on update" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object
			object.reload.update_attributes(:first_name => "New First Name")
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

	test "should allow multiple blank email" do
		create_object(:email => '  ')
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:email => ' ')
		end
	end

	test "should require properly formated email address" do
		assert_difference( "#{model_name}.count", 0 ) do
			%w( asdf me@some@where.com ).each do |bad_email|
				object = create_object(:email => bad_email)
				assert object.errors.on(:email)
			end
		end
		assert_difference( "#{model_name}.count", 1 ) do
			%w( me@some.where.com ).each do |good_email|
				object = create_object(:email => good_email)
				assert !object.errors.on(:email)
			end
		end
	end

	test "should return dob as a date NOT time" do
		object = create_object
		assert_changes("Pii.find(#{object.id}).dob") {
			object.update_attribute(:dob, Chronic.parse('tomorrow at noon'))
		}
		assert !object.new_record?
		assert_not_nil object.dob
		assert object.dob.is_a?(Date)
		assert_equal object.dob, object.dob.to_date
	end

	test "should parse a properly formatted date" do
		#	Chronic won't parse this correctly,
		#	but Date.parse will. ???
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(
				:dob => Chronic.parse("January 1 2001"))
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

end
