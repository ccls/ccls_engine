require File.dirname(__FILE__) + '/../test_helper'

class OrganizationTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_require_attributes( :code )
	assert_should_require_attributes( :name )
	assert_should_require_unique_attributes( :code )
	assert_should_require_unique_attributes( :name )
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :person_id )
	assert_should_belong_to( :person )
	assert_should_have_many( :hospitals )
	assert_should_have_many( :patients )

	assert_should_have_many(:aliquots, 
		:foreign_key => :owner_id)

	with_options :class_name => 'Transfer' do |o|
		o.assert_should_have_many(:incoming_transfers, 
			:foreign_key => :to_organization_id)
		o.assert_should_have_many(:outgoing_transfers, 
			:foreign_key => :from_organization_id)
	end
	with_options :minimum => 4, :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :code )
		o.assert_should_require_attribute_length( :name )
	end

	test "new incoming_transfer should have matching organization id" do
		organization = create_organization
		transfer = organization.incoming_transfers.build
		assert_equal organization.id, transfer.to_organization_id
	end

	test "new outgoing_transfer should have matching organization id" do
		organization = create_organization
		transfer = organization.outgoing_transfers.build
		assert_equal organization.id, transfer.from_organization_id
	end

	test "should have many samples" do
#		somehow

#		flunk samples

#	TODO

		#	this is unclear in my diagram
		pending

	end

	test "should return name as to_s" do
		organization = create_organization
		assert_equal organization.name, "#{organization}"
	end

end
