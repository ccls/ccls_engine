require 'test_helper'

class Ccls::SampleKitTest < ActiveSupport::TestCase

#	Remove all package references and add tracking numbers here

	assert_should_create_default_object
	assert_should_initially_belong_to( :sample )
#	assert_should_belong_to( :sample_package, :kit_package, 
#		:class_name => 'Package' )
	assert_should_require_unique_attribute( :sample_id )
#	assert_should_not_require_attributes( :kit_package_id, :sample_package_id )

	test "explicit Factory sample_kit test" do
		assert_difference('Sample.count',1) {
		assert_difference('SampleKit.count',1) {
			sample_kit = Factory(:sample_kit)
			assert_not_nil sample_kit.sample
		} }
	end

#	test "should create sample kit with kit package" do
#		assert_difference( "SampleKit.count", 1 ) {
#		assert_difference('Package.count', 1) {
#			sample_kit = create_sample_kit(
#				:kit_package_attributes => Factory.attributes_for(:package) )
#		} }
#	end
#
#	test "should create sample kit with sample package" do
#		assert_difference( "SampleKit.count", 1 ) {
#		assert_difference('Package.count', 1) {
#			sample_kit = create_sample_kit(
#				:sample_package_attributes => Factory.attributes_for(:package) )
#		} }
#	end
#
#	test "should create sample kit with both packages" do
#		assert_difference( "SampleKit.count", 1 ) {
#		assert_difference('Package.count', 2) {
#			sample_kit = create_sample_kit(
#				:kit_package_attributes  => Factory.attributes_for(:package),
#				:sample_package_attributes => Factory.attributes_for(:package) 
#			)
#		} }
#	end

	test "should require a unique sample" do
		assert_difference( "SampleKit.count", 1 ) {
		assert_difference('Sample.count', 1) {
			sample_kit = create_sample_kit
			assert_not_nil sample_kit.sample
			sample_kit = create_sample_kit(:sample_id => sample_kit.sample_id)
			assert sample_kit.errors.on(:sample_id)
		} }
	end

#	test "should returned status New" do
#		sample_kit = create_complete_sample_kit	
#		assert_equal 'New', sample_kit.status
#	end
#
#	test "should returned status Shipped" do
#		sample_kit = create_complete_sample_kit	
#		sample_kit.kit_package.update_attributes(:status => 'Transit')
#		assert_equal 'Shipped', sample_kit.status
#	end
#
#	test "should returned status Delivered" do
#		sample_kit = create_complete_sample_kit	
#		sample_kit.kit_package.update_attributes(:status => 'Delivered')
#		assert_equal 'Delivered', sample_kit.status
#	end
#
#	test "should returned status Returned" do
#		sample_kit = create_complete_sample_kit	
#		sample_kit.sample_package.update_attributes(:status => 'Transit')
#		assert_equal 'Returned', sample_kit.status
#	end
#
#	test "should returned status Received" do
#		sample_kit = create_complete_sample_kit	
#		sample_kit.sample_package.update_attributes(:status => 'Delivered')
#		assert_equal 'Received', sample_kit.status
#	end
#
#	test "should return null sent_on with new kit" do
#		sample_kit = create_complete_sample_kit	
#		assert_nil sample_kit.sent_on
#	end
#
#	test "should return null received_on with new kit" do
#		sample_kit = create_complete_sample_kit	
#		assert_nil sample_kit.received_on
#	end
#
#	test "should return date sent_on with kit in transit" do
#		stub_package_for_in_transit()
#		sample_kit = create_complete_sample_kit	
#		sample_kit.kit_package.update_status
#		assert_not_nil sample_kit.reload.sent_on
#	end
#
#	test "should return null received_on with kit in transit" do
#		stub_package_for_in_transit()
#		sample_kit = create_complete_sample_kit	
#		sample_kit.kit_package.update_status
#		assert_nil sample_kit.received_on
#	end
#
#	test "should return date sent_on with kit returned" do
#		stub_package_for_successful_delivery()
#		sample_kit = create_complete_sample_kit	
#		sample_kit.kit_package.update_status
#		sample_kit.sample_package.update_status
#		assert_not_nil sample_kit.sent_on
#	end
#
#	test "should return date received_on with kit returned" do
#		stub_package_for_successful_delivery()
#		sample_kit = create_complete_sample_kit	
#		sample_kit.sample_package.update_status
#		assert_not_nil sample_kit.received_on
#	end
#
#	test "should set sample sent_to_subject_on" do
#		stub_package_for_in_transit()
#		sample_kit = create_complete_sample_kit	
#		sample = sample_kit.sample
#		sample_kit.kit_package.update_status
#		assert_not_nil sample_kit.kit_package.tracks.first
#		assert_not_nil sample.reload.sent_to_subject_on
#		assert_equal sample_kit.kit_package.tracks.first.time.to_date,
#			sample.reload.sent_to_subject_on
#	end
#
#	test "should set sample received_by_ccls_on" do
#		stub_package_for_successful_delivery()
#		sample_kit = create_complete_sample_kit	
#		sample = sample_kit.sample
#		sample_kit.sample_package.update_status
#		assert_not_nil sample_kit.sample_package.tracks.last
#		assert_not_nil sample.reload.received_by_ccls_on
#		assert_equal sample_kit.sample_package.tracks.last.time.to_date,
#			sample.reload.received_by_ccls_on
#	end

protected

	def create_complete_sample_kit(options={})
		sample_kit = create_sample_kit(
#			:kit_package_attributes    => Factory.attributes_for(:package),
#			:sample_package_attributes => Factory.attributes_for(:package) 
		)
	end

#	def create_sample_kit(options={})
#		sample_kit = Factory.build(:sample_kit,options)
#		sample_kit.save
#		sample_kit
#	end

end
