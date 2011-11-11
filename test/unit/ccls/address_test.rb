require 'test_helper'

class Ccls::AddressTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes( 
		:line_1, 
		:city, 
		:state, 
		:zip )
	assert_should_not_require_attributes( 
		:line_2, 
		:unit,
#		:data_source_id, 
		:external_address_id )
	assert_should_require_attribute_length( 
		:zip, 
			:maximum => 10 )
	assert_should_require_attribute_length( 
		:line_1, 
		:line_2, 
		:unit,
		:city, 
		:state,
			:maximum => 250 )

	assert_should_have_one(:addressing)
	assert_should_have_many(:interviews)
#	assert_should_belong_to(:data_source)
	assert_should_initially_belong_to(:address_type)

	test "explicit Factory address test" do
		assert_difference('AddressType.count',1) {
		assert_difference('Address.count',1) {
			address = Factory(:address)
			assert_not_nil address.address_type
			assert_match /Box \d*/, address.line_1
			assert_equal "Berkeley", address.city
			assert_equal "CA", address.state
			assert_equal "12345", address.zip
		} }
	end

	test "should require address_type" do
		assert_difference( "Address.count", 0 ) do
			address = create_address( :address_type => nil)
			assert address.errors.on(:address_type)
		end
	end

	test "should require valid address_type" do
		assert_difference( "Address.count", 0 ) do
			address = create_address( :address_type_id => 0)
			assert address.errors.on(:address_type)
		end
	end

	test "should require 5 or 9 digit zip" do
		%w( asdf 1234 123456 1234Q ).each do |bad_zip|
			assert_difference( "Address.count", 0 ) do
				address = create_address( :zip => bad_zip )
				assert address.errors.on(:zip)
			end
		end
		%w( 12345 12345-6789 123456789 ).each do |good_zip|
			assert_difference( "Address.count", 1 ) do
				address = create_address( :zip => good_zip )
				assert !address.errors.on(:zip)
				assert address.zip =~ /\A\d{5}(-)?(\d{4})?\z/
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
		assert_difference( "Address.count", 0 ) do
			address = create_address( 
				:line_1 => "P.O. Box 123",
				:address_type => AddressType['residence']
			)
			assert address.errors.on(:address_type_id)
		end
	end

protected

	def create_address(options={})
		address = Factory.build(:address,options)
		address.save
		address
	end

end
