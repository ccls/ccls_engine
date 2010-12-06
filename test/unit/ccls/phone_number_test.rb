require File.dirname(__FILE__) + '/../test_helper'

class PhoneNumberTest < ActiveSupport::TestCase

	assert_should_create_default_object

#	TODO
#	assert_should_act_as_list( :scope => :study_subject_id )

	assert_should_initially_belong_to( :subject )
	assert_should_initially_belong_to( :phone_type )
	assert_should_require_attribute(:phone_number)
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :study_subject_id )
	assert_should_not_require_attributes( :phone_type_id )
	assert_should_not_require_attributes( :data_source_id )
	assert_should_not_require_attributes( :is_primary )
	assert_should_not_require_attributes( :is_valid )
	assert_should_not_require_attributes( :why_invalid )
	assert_should_not_require_attributes( :is_verified )
	assert_should_not_require_attributes( :how_verified )
	assert_should_not_require_attributes( :verified_on )
	assert_should_not_require_attributes( :verified_by_id )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :how_verified )
		o.assert_should_require_attribute_length( :why_invalid )
	end


	test "should require properly formated phone number" do
		[ 'asdf', 'me@some@where.com','12345678','12345678901' 
		].each do |bad_phone|
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object(:phone_number => bad_phone)
				assert object.errors.on(:phone_number)
			end
		end
		[ "(123)456-7890", "1234567890", 
			"  1 asdf23,4()5\+67   8 9   0asdf" ].each do |good_phone|
			assert_difference( "#{model_name}.count", 1 ) do
				object = create_object(:phone_number => good_phone)
				assert !object.errors.on(:phone_number)
				assert object.reload.phone_number =~ /\A\(\d{3}\)\s+\d{3}-\d{4}\z/
			end
		end
	end

	test "should NOT require why_invalid if is_valid is nil" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:is_valid => nil)
		end
	end

	test "should NOT require why_invalid if is_valid is :yes" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:is_valid => YNDK[:yes])
		end
	end

	test "should NOT require why_invalid if is_valid is :dk" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:is_valid => YNDK[:dk])
		end
	end

	test "should require why_invalid if is_valid is :no" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:is_valid => YNDK[:no])
			assert object.errors.on(:why_invalid)
		end
	end

	test "should NOT require how_verified if is_verified is false" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:is_verified => false)
		end
	end

	test "should require how_verified if is_verified is true" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:is_verified => true)
			assert object.errors.on(:how_verified)
		end
	end

	test "should NOT set verified_on if is_verified NOT changed to true" do
		object = create_object(:is_verified => false)
		assert_nil object.verified_on
	end

	test "should set verified_on if is_verified changed to true" do
		object = create_object(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil object.verified_on
	end

	test "should set verified_on to NIL if is_verified changed to false" do
		object = create_object(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil object.verified_on
		object.update_attributes(:is_verified => false)
		assert_nil object.verified_on
	end

	test "should NOT set verified_by_id if is_verified NOT changed to true" do
		object = create_object(:is_verified => false)
		assert_nil object.verified_by_id
	end

	test "should set verified_by_id to 0 if is_verified changed to true" do
		object = create_object(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil object.verified_by_id
		assert_equal object.verified_by_id, 0
	end

	test "should set verified_by_id to current_user.id if is_verified " <<
		"changed to true if current_user passed" do
		cu = admin_user
		object = create_object(:is_verified => true,
			:current_user => cu,
			:how_verified => "not a clue")
		assert_not_nil object.verified_by_id
		assert_equal object.verified_by_id, cu.id
	end

	test "should set verified_by_id to NIL if is_verified changed to false" do
		object = create_object(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil object.verified_by_id
		object.update_attributes(:is_verified => false)
		assert_nil object.verified_by_id
	end

end
