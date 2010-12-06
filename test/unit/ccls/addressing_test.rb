require File.dirname(__FILE__) + '/../test_helper'

class AddressingTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_not_require_attributes( :address_id )
	assert_should_not_require_attributes( :current_address )
	assert_should_not_require_attributes( :address_at_diagnosis )
	assert_should_not_require_attributes( :is_valid )
	assert_should_not_require_attributes( :why_invalid )
	assert_should_not_require_attributes( :is_verified )
	assert_should_not_require_attributes( :how_verified )
	assert_should_not_require_attributes( :valid_from )
	assert_should_not_require_attributes( :valid_to )
	assert_should_not_require_attributes( :verified_on )
	assert_should_not_require_attributes( :verified_by_id )
	assert_should_not_require_attributes( :data_source_id )
	assert_should_initially_belong_to(:subject)
	assert_should_initially_belong_to(:address)
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :why_invalid )
		o.assert_should_require_attribute_length( :how_verified )
	end
	assert_requires_complete_date(:valid_from)
	assert_requires_complete_date(:valid_to)

	#
	# addressing uses accepts_attributes_for :address
	# so the addressing can't require address_id on create
	# or this test fails.
	#
	test "should require address_id on update" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object(:address_id => nil)
			object.reload.update_attributes(
				:created_at => Chronic.parse('yesterday'))
			assert object.errors.on(:address)
		end
	end

	[:yes,:dk,:nil].each do |yndk|
		test "should NOT require why_invalid if is_valid is #{yndk}" do
			assert_difference( "#{model_name}.count", 1 ) do
				object = create_object(:is_valid => YNDK[yndk])
			end
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


	test "should only return current addressings" do
		create_object(:current_address => YNDK[:yes])
		create_object(:current_address => YNDK[:no])
		create_object(:current_address => YNDK[:dk])
		objects = Addressing.current
		objects.each do |object|
			assert_equal 1, object.current_address
		end
	end

	test "should only return historic addressings" do
		create_object(:current_address => YNDK[:yes])
		create_object(:current_address => YNDK[:no])
		create_object(:current_address => YNDK[:dk])
		objects = Addressing.historic
		objects.each do |object|
			assert_not_equal 1, object.current_address
		end
	end



	test "should make subject ineligible "<<
			"on create if state NOT 'CA' and address is ONLY residence" do
		subject = create_eligible_hx_subject
		assert_difference('OperationalEvent.count',1) {
		assert_difference('Addressing.count',1) {
		assert_difference('Address.count',1) {
			create_az_addressing(subject)
		} } }
		assert_subject_is_not_eligible(subject)
		assert_equal   subject.hx_enrollment.ineligible_reason,
			IneligibleReason['newnonCA']
	end

	test "should make subject ineligible "<<
			"on create if state NOT 'CA' and address is ANOTHER residence" do
		subject = create_eligible_hx_subject
		assert_difference('OperationalEvent.count',1) {
		assert_difference('Address.count',2) {
		assert_difference( "#{model_name}.count", 2 ) {
			create_ca_addressing(subject)
			create_az_addressing(subject)
		} } }
		assert_subject_is_not_eligible(subject)
		assert_equal   subject.hx_enrollment.ineligible_reason,
			IneligibleReason['moved']
	end

	test "should NOT make subject ineligible "<<
			"on create if OET is missing" do
		OperationalEventType['ineligible'].destroy
		subject = create_eligible_hx_subject
		assert_difference('OperationalEvent.count',0) {
		assert_difference('Address.count',1) {
		assert_difference( "#{model_name}.count", 1 ) {
			create_ca_addressing(subject)
			assert_raise(ActiveRecord::RecordNotSaved){
				create_az_addressing(subject)
		} } } }
		subject.hx_enrollment.reload	#	NEEDED
		assert_subject_is_eligible(subject)
	end

	test "should NOT make subject ineligible "<<
			"on create if state NOT 'CA' and address is NOT residence" do
		subject = create_eligible_hx_subject
		assert_difference('OperationalEvent.count',0) {
		assert_difference('Address.count',1) {
		assert_difference( "#{model_name}.count", 1 ) {
			create_az_addressing(subject,
				:address => { :address_type => AddressType['mailing'] })
		} } }
		assert_subject_is_eligible(subject)
	end

	test "should NOT make subject ineligible "<<
			"on create if state 'CA' and address is residence" do
		subject = create_eligible_hx_subject
		assert_difference('OperationalEvent.count',0) {
		assert_difference('Address.count',1) {
		assert_difference( "#{model_name}.count", 1 ) {
			create_ca_addressing(subject)
		} } }
		assert_subject_is_eligible(subject)
	end

protected

	def create_addressing_with_address(subject,options={})
#		Factory(:addressing, {
		create_object({
			:subject => subject,
#	doesn't work in rcov for some reason
#			:address => nil,	#	block address_attributes
			:address_id => nil,	#	block address_attributes
			:address_attributes => Factory.attributes_for(:address,{
				:address_type => AddressType['residence']
			}.merge(options[:address]||{}))
		}.merge(options[:addressing]||{}))
	end

	def create_ca_addressing(subject,options={})
		create_addressing_with_address(subject,{
			:address => {:state => 'CA'}}.merge(options))
	end

	def create_az_addressing(subject,options={})
		create_addressing_with_address(subject,{
			:address => {:state => 'AZ'}}.merge(options))
	end

end
