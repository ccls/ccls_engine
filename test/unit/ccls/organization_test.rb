require 'test_helper'

class Ccls::OrganizationTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash( :value => :name )

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_not_require_attributes( :position, :person_id )
	assert_should_belong_to( :person )
	assert_should_have_many( :patients )
#	assert_should_have_many( :hospitals )
	assert_should_have_one(  :hospital )

	assert_should_have_many(:aliquots, 
		:foreign_key => :owner_id)

	with_options :class_name => 'Transfer' do |o|
		o.assert_should_have_many(:incoming_transfers, 
			:foreign_key => :to_organization_id)
		o.assert_should_have_many(:outgoing_transfers, 
			:foreign_key => :from_organization_id)
	end

	test "explicit Factory organization test" do
		assert_difference('Organization.count',1) {
			organization = Factory(:organization)
			assert_match /Key \d*/,  organization.key
			assert_match /Name \d*/, organization.name
		}
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

#	TODO haven't really implemented organization samples yet
#	test "should have many samples" do
#		#	this is unclear in my diagram
#		pending
#	end

	test "should return name as to_s" do
		organization = create_organization
		assert_equal organization.name, "#{organization}"
	end

#protected
#
#	def create_organization(options={})
#		organization = Factory.build(:organization,options)
#		organization.save
#		organization
#	end

end
