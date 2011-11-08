require 'test_helper'

class Ccls::PhoneNumberTest < ActiveSupport::TestCase

	assert_should_create_default_object

	assert_should_act_as_list( :scope => :study_subject_id )

	assert_should_initially_belong_to( :study_subject, :phone_type )
	assert_should_require_attribute(:phone_number )	#, :phone_type_id )
	assert_should_not_require_attributes( :position, :study_subject_id,
		:data_source_id, :is_primary, :is_valid,
		:why_invalid, :is_verified, :how_verified,
		:verified_on, :verified_by_uid, :current_phone )
	assert_should_require_attribute_length( :how_verified, :why_invalid, 
		:maximum => 250 )

	test "should require phone_type" do
		assert_difference( "PhoneNumber.count", 0 ) do
			phone_number = create_phone_number( :phone_type => nil)
			assert phone_number.errors.on(:phone_type)
		end
	end

	test "should require valid phone_type" do
		assert_difference( "PhoneNumber.count", 0 ) do
			phone_number = create_phone_number( :phone_type_id => 0)
			assert phone_number.errors.on(:phone_type)
		end
	end

	test "current_phone should default to 1" do
		phone_number = PhoneNumber.new
		assert_equal 1, phone_number.current_phone
	end

	test "should only return current phone_numbers" do
		create_phone_number(:current_phone => YNDK[:yes])
		create_phone_number(:current_phone => YNDK[:no])
		create_phone_number(:current_phone => YNDK[:dk])
		phone_numbers = PhoneNumber.current
		assert_equal 2, phone_numbers.length
		phone_numbers.each do |phone_number|
			assert [1,999].include?(phone_number.current_phone)
		end
	end

	test "should only return historic phone_numbers" do
		create_phone_number(:current_phone => YNDK[:yes])
		create_phone_number(:current_phone => YNDK[:no])
		create_phone_number(:current_phone => YNDK[:dk])
		phone_numbers = PhoneNumber.historic
		assert_equal 1, phone_numbers.length
		phone_numbers.each do |phone_number|
			assert ![1,999].include?(phone_number.current_phone)
		end
	end

	test "should require properly formated phone number" do
		[ 'asdf', 'me@some@where.com','12345678','12345678901' 
		].each do |bad_phone|
			assert_difference( "PhoneNumber.count", 0 ) do
				phone_number = create_phone_number(:phone_number => bad_phone)
				assert phone_number.errors.on(:phone_number)
			end
		end
		[ "(123)456-7890", "1234567890", 
			"  1 asdf23,4()5\+67   8 9   0asdf" ].each do |good_phone|
			assert_difference( "PhoneNumber.count", 1 ) do
				phone_number = create_phone_number(:phone_number => good_phone)
				assert !phone_number.errors.on(:phone_number)
				assert phone_number.reload.phone_number =~ /\A\(\d{3}\)\s+\d{3}-\d{4}\z/
			end
		end
	end

	[:yes,:nil].each do |yndk|
		test "should NOT require why_invalid if is_valid is #{yndk}" do
			assert_difference( "PhoneNumber.count", 1 ) do
				phone_number = create_phone_number(:is_valid => YNDK[yndk])
			end
		end
	end
	[:no,:dk].each do |yndk|
		test "should require why_invalid if is_valid is #{yndk}" do
			assert_difference( "PhoneNumber.count", 0 ) do
				phone_number = create_phone_number(:is_valid => YNDK[yndk])
				assert phone_number.errors.on(:why_invalid)
			end
		end
	end

	test "should NOT require how_verified if is_verified is false" do
		assert_difference( "PhoneNumber.count", 1 ) do
			phone_number = create_phone_number(:is_verified => false)
		end
	end

	test "should require how_verified if is_verified is true" do
		assert_difference( "PhoneNumber.count", 0 ) do
			phone_number = create_phone_number(:is_verified => true)
			assert phone_number.errors.on(:how_verified)
		end
	end

	test "should NOT set verified_on if is_verified NOT changed to true" do
		phone_number = create_phone_number(:is_verified => false)
		assert_nil phone_number.verified_on
	end

	test "should set verified_on if is_verified changed to true" do
		phone_number = create_phone_number(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil phone_number.verified_on
	end

	test "should set verified_on to NIL if is_verified changed to false" do
		phone_number = create_phone_number(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil phone_number.verified_on
		phone_number.update_attributes(:is_verified => false)
		assert_nil phone_number.verified_on
	end

	test "should NOT set verified_by_uid if is_verified NOT changed to true" do
		phone_number = create_phone_number(:is_verified => false)
		assert_nil phone_number.verified_by_uid
	end

	test "should set verified_by_uid to 0 if is_verified changed to true" do
		phone_number = create_phone_number(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil phone_number.verified_by_uid
		assert_equal phone_number.verified_by_uid, ''
	end

	test "should set verified_by_uid to current_user.id if is_verified " <<
		"changed to true if current_user passed" do
		cu = admin_user
		phone_number = create_phone_number(:is_verified => true,
			:current_user => cu,
			:how_verified => "not a clue")
		assert_not_nil phone_number.verified_by_uid
		assert_equal phone_number.verified_by_uid, cu.uid
	end

	test "should set verified_by_uid to NIL if is_verified changed to false" do
		phone_number = create_phone_number(:is_verified => true,
			:how_verified => "not a clue")
		assert_not_nil phone_number.verified_by_uid
		phone_number.update_attributes(:is_verified => false)
		assert_nil phone_number.verified_by_uid
	end

protected

	def create_phone_number(options={})
		phone_number = Factory.build(:phone_number,options)
		phone_number.save
		phone_number
	end

end
