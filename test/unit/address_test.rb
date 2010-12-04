require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes( :line_1 )
	assert_should_require_attributes( :city )
	assert_should_require_attributes( :state )
	assert_should_require_attributes( :zip )
	assert_should_not_require_attributes( :line_2 )
	assert_should_not_require_attributes( :data_source_id )
	assert_should_not_require_attributes( :external_address_id )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :line_1 )
		o.assert_should_require_attribute_length( :line_2 )
		o.assert_should_require_attribute_length( :city )
		o.assert_should_require_attribute_length( :state )
	end
	assert_should_have_one(:addressing)
	assert_should_have_many(:interviews)
	assert_should_belong_to(:data_source)
	assert_should_initially_belong_to(:address_type)


	test "should require 5 or 9 digit zip" do
		%w( asdf 1234 123456 1234Q 123456789 ).each do |bad_zip|
			assert_difference( "#{model_name}.count", 0 ) do
				object = create_object( :zip => bad_zip )
				assert object.errors.on(:zip)
			end
		end
		%w( 12345 12345-6789 ).each do |good_zip|
			assert_difference( "#{model_name}.count", 1 ) do
				object = create_object( :zip => good_zip )
				assert !object.errors.on(:zip)
				assert object.zip =~ /\A\d{5}(-\d{4})?\z/
			end
		end
	end

	test "should order address chronologically reversed" do
		a1 = Factory(:address, :created_at => Date.jd(2440000) ).id
		a2 = Factory(:address, :created_at => Date.jd(2450000) ).id
		a3 = Factory(:address, :created_at => Date.jd(2445000) ).id
		address_ids = Address.all.collect(&:id)
		assert_equal address_ids, [a2,a3,a1]
	end

	test "should return city state and zip with csz" do
		address = Factory(:address,
			:city => 'City',
			:state => 'CA',
			:zip   => '12345')
		assert_equal "City, CA 12345", address.csz
	end

	test "should require non-residence address type with pobox in line" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object({
				:line_1 => "P.O. Box 123",
				:address_type => AddressType['residence']
			})
			assert object.errors.on(:address_type_id)
		end
	end

end
