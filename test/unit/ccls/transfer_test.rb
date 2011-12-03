require 'test_helper'

class Ccls::TransferTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to( :aliquot )
	assert_should_initially_belong_to( :to_organization, :from_organization, 
		:class_name => 'Organization' )
#	assert_should_require_attributes( :aliquot_id, 
#		:from_organization_id, :to_organization_id )
	assert_should_not_require_attributes( :position, :amount, :reason, :is_permanent )
	assert_should_require_attribute_length( :reason, :maximum => 250 )

	test "explicit Factory transfer test" do
		assert_difference('Organization.count',3) {	#	aliquot also creates an Organization
		assert_difference('Aliquot.count',1) {
		assert_difference('Transfer.count',1) {
			transfer = Factory(:transfer)
			assert_not_nil transfer.aliquot
			assert_not_nil transfer.from_organization
			assert_not_nil transfer.to_organization
		} } }
	end

	test "should require aliquot" do
		assert_difference( "Transfer.count", 0 ) do
			transfer = create_transfer( :aliquot => nil)
			assert !transfer.errors.on(:aliquot)
			assert  transfer.errors.on_attr_and_type?(:aliquot_id,:blank)
		end
	end

	test "should require valid aliquot" do
		assert_difference( "Transfer.count", 0 ) do
			transfer = create_transfer( :aliquot_id => 0)
			assert !transfer.errors.on(:aliquot_id)
			assert  transfer.errors.on_attr_and_type?(:aliquot,:blank)
		end
	end

	test "should require from_organization" do
		assert_difference( "Transfer.count", 0 ) do
			transfer = create_transfer( :from_organization => nil)
			assert !transfer.errors.on(:from_organization)
			assert  transfer.errors.on_attr_and_type?(:from_organization_id,:blank)
		end
	end

	test "should require valid from_organization" do
		assert_difference( "Transfer.count", 0 ) do
			transfer = create_transfer( :from_organization_id => 0)
			assert !transfer.errors.on(:from_organization_id)
			assert  transfer.errors.on_attr_and_type?(:from_organization,:blank)
		end
	end

	test "should require to_organization" do
		assert_difference( "Transfer.count", 0 ) do
			transfer = create_transfer( :to_organization => nil)
			assert !transfer.errors.on(:to_organization)
			assert  transfer.errors.on_attr_and_type?(:to_organization_id,:blank)
		end
	end

	test "should require valid to_organization" do
		assert_difference( "Transfer.count", 0 ) do
			transfer = create_transfer( :to_organization_id => 0)
			assert !transfer.errors.on(:to_organization_id)
			assert  transfer.errors.on_attr_and_type?(:to_organization,:blank)
		end
	end

#protected
#
#	def create_transfer(options={})
#		transfer = Factory.build(:transfer,options)
#		transfer.save
#		transfer
#	end

end
