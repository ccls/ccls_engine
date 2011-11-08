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

	test "should require aliquot" do
		assert_difference( "Transfer.count", 0 ) do
			transfer = create_transfer( :aliquot => nil)
			assert transfer.errors.on(:aliquot)
		end
	end

	test "should require valid aliquot" do
		assert_difference( "Transfer.count", 0 ) do
			transfer = create_transfer( :aliquot_id => 0)
			assert transfer.errors.on(:aliquot)
		end
	end

	test "should require from_organization" do
		assert_difference( "Transfer.count", 0 ) do
			transfer = create_transfer( :from_organization => nil)
			assert transfer.errors.on(:from_organization)
		end
	end

	test "should require valid from_organization" do
		assert_difference( "Transfer.count", 0 ) do
			transfer = create_transfer( :from_organization_id => 0)
			assert transfer.errors.on(:from_organization)
		end
	end

	test "should require to_organization" do
		assert_difference( "Transfer.count", 0 ) do
			transfer = create_transfer( :to_organization => nil)
			assert transfer.errors.on(:to_organization)
		end
	end

	test "should require valid to_organization" do
		assert_difference( "Transfer.count", 0 ) do
			transfer = create_transfer( :to_organization_id => 0)
			assert transfer.errors.on(:to_organization)
		end
	end

protected

	def create_transfer(options={})
		transfer = Factory.build(:transfer,options)
		transfer.save
		transfer
	end

end
