require 'test_helper'

class Ccls::AliquotTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_not_require_attributes( 
		:position,
		:aliquot_sample_format_id,
		:location,
		:mass,
		:external_aliquot_id,
		:external_aliquot_id_source )
	assert_should_require_attribute_length( 
		:location, 
		:mass, 
			:maximum => 250 )
	assert_should_have_many(:transfers)
	assert_should_belong_to( :aliquot_sample_format )
	assert_should_initially_belong_to( :sample, :unit )
	assert_should_initially_belong_to( :owner, :class_name => 'Organization' )

	test "explicit Factory aliquot test" do
		assert_difference('Sample.count',1) {
		assert_difference('Unit.count',1) {
		assert_difference('Organization.count',1) {
		assert_difference('Aliquot.count',1) {
			aliquot = Factory(:aliquot)
			assert_not_nil aliquot.sample
			assert_not_nil aliquot.unit
			assert_not_nil aliquot.owner
		} } } }
	end

	test "should require owner" do
		assert_difference( "Aliquot.count", 0 ) do
			aliquot = create_aliquot( :owner => nil)
			assert aliquot.errors.on(:owner)
		end
	end

	test "should require valid owner" do
		assert_difference( "Aliquot.count", 0 ) do
			aliquot = create_aliquot( :owner_id => 0)
			assert aliquot.errors.on(:owner)
		end
	end

	test "should require unit" do
		assert_difference( "Aliquot.count", 0 ) do
			aliquot = create_aliquot( :unit => nil)
			assert aliquot.errors.on(:unit)
		end
	end

	test "should require valid unit" do
		assert_difference( "Aliquot.count", 0 ) do
			aliquot = create_aliquot( :unit_id => 0)
			assert aliquot.errors.on(:unit)
		end
	end

	test "should require sample" do
		assert_difference( "Aliquot.count", 0 ) do
			aliquot = create_aliquot( :sample => nil)
			assert aliquot.errors.on(:sample)
		end
	end

	test "should require valid sample" do
		assert_difference( "Aliquot.count", 0 ) do
			aliquot = create_aliquot( :sample_id => 0)
			assert aliquot.errors.on(:sample)
		end
	end


	test "should transfer to another organization" do
		aliquot = create_aliquot
		initial_owner = aliquot.owner
		assert_not_nil initial_owner
		new_owner = Factory(:organization)
		assert_difference('aliquot.reload.owner_id') {
		assert_difference('aliquot.transfers.count', 1) {
#		assert_difference('initial_owner.reload.aliquots_count', -1) {
		assert_difference('initial_owner.aliquots.count', -1) {
#		assert_difference('new_owner.reload.aliquots_count', 1) {
		assert_difference('new_owner.aliquots.count', 1) {
		assert_difference('Transfer.count',1) {
			aliquot.transfer_to(new_owner)
		} } } } } #} }
		assert_not_nil aliquot.reload.owner
	end

	test "should NOT transfer if aliquot owner update fails" do
		aliquot = create_aliquot
		initial_owner = aliquot.owner
		assert_not_nil initial_owner
		new_owner = Factory(:organization)
		Aliquot.any_instance.stubs(:update_attribute).returns(false)
		assert_no_difference('aliquot.reload.owner_id') {
		assert_no_difference('aliquot.transfers.count') {
		assert_no_difference('initial_owner.aliquots.count') {
#		assert_no_difference('initial_owner.aliquots_count') {
		assert_no_difference('new_owner.aliquots.count') {
#		assert_no_difference('new_owner.aliquots_count') {
		assert_no_difference('Transfer.count') {
		assert_raise(ActiveRecord::RecordNotSaved){
			aliquot.transfer_to(new_owner)
		} } } } } } #} }
		assert_not_nil aliquot.reload.owner
	end

	test "should NOT transfer if transfer creation fails" do
		aliquot = create_aliquot
		initial_owner = aliquot.owner
		assert_not_nil initial_owner
		new_owner = Factory(:organization)
		Transfer.any_instance.stubs(:save!).raises(
			ActiveRecord::RecordInvalid.new(Transfer.new))
		assert_no_difference('aliquot.reload.owner_id') {
		assert_no_difference('aliquot.transfers.count') {
		assert_no_difference('initial_owner.aliquots.count') {
#		assert_no_difference('initial_owner.aliquots_count') {
		assert_no_difference('new_owner.aliquots.count') {
#		assert_no_difference('new_owner.aliquots_count') {
		assert_no_difference('Transfer.count') {
		assert_raise(ActiveRecord::RecordInvalid){
			aliquot.transfer_to(new_owner)
		} } } } } } #} }
		assert_not_nil aliquot.reload.owner
	end

	test "should NOT transfer to invalid organization" do
		aliquot = create_aliquot
		initial_owner = aliquot.owner
		assert_not_nil initial_owner
		assert_no_difference('aliquot.reload.owner_id') {
		assert_no_difference('aliquot.transfers.count') {
#		assert_no_difference('initial_owner.aliquots_count') {
		assert_no_difference('initial_owner.aliquots.count') {
		assert_no_difference('Transfer.count') {
		assert_raise(ActiveRecord::RecordNotFound){
			aliquot.transfer_to(0)
		} } } } } #}
		assert_not_nil aliquot.reload.owner
	end

protected

	def create_aliquot(options={})
		aliquot = Factory.build(:aliquot,options)
		aliquot.save
		aliquot
	end

end
