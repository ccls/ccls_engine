require File.dirname(__FILE__) + '/../test_helper'

class PackageTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_unique_attribute(:tracking_number)
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :status )
	assert_should_not_require_attributes( :tracks_count )
	assert_should_not_require_attributes( :tracking_number )
	assert_should_not_require_attributes( :latest_event )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :status )
		o.assert_should_require_attribute_length( :tracking_number )
		o.assert_should_require_attribute_length( :latest_event )
	end

	test "should NOT require 3 char tracking_number" do
		assert_difference( "#{model_name}.count", 1 ) do
			package = create_package(:tracking_number => 'Hi')
			assert !package.errors.on(:tracking_number)
		end
	end

	test "should have no status when created" do
		package = create_package
		assert_nil package.status
	end

	test "should have failure status for bogus tracking_number" do
		stub_package_for_failure()
		assert_difference( 'Package.delivered.count', 0 ) {
		assert_difference( 'Package.undelivered.count', 1 ) {
			package = create_package(:tracking_number => 'obviouslybogus')
			package.update_status
			assert_match "failed", package.status
		} }
	end

	test "should have delivered status for delivered tracking_number" do
		stub_package_for_successful_delivery()
		assert_difference( 'Package.delivered.count', 1 ) {
		assert_difference( 'Package.undelivered.count', 0 ) {
			#	this number was taken from the active_shipping tests
			package = create_package(:tracking_number => '077973360403984')
			package.update_status
			assert_match "Delivered", package.status
		} }
	end

	test "should update status for undelivered" do
		stub_package_for_successful_delivery()
		package = create_package(:tracking_number => '077973360403984')
		assert_difference( 'Package.delivered.count', 1 ) {
		assert_difference( 'Package.undelivered.count', -1 ) {
			Package.update_undelivered
		} }
	end

	test "should set and get packages updated time" do
		if File.exists?(Package.packages_updated)
			File.delete(Package.packages_updated)
		end
		assert !File.exists?(Package.packages_updated)
		assert_nil Package.last_updated
		Package.just_updated
		assert File.exists?(Package.packages_updated)
		assert_in_delta Package.last_updated.to_f,
			Time.now.to_f, 2
	end

	test "should not be delivered? when new" do
		package = create_package
		assert !package.delivered?
	end

	test "should not be delivered? when in transit" do
		stub_package_for_in_transit()
		package = create_package
		assert !package.delivered?
		package.update_status
		assert !package.delivered?
		assert_equal 'Transit', package.status
	end

	test "should be delivered? when delivered" do
		stub_package_for_successful_delivery()
		package = create_package
		assert !package.delivered?
		package.update_status
		assert package.delivered?
	end

	test "should return null sent_on when new" do
		package = create_package
		assert_nil package.sent_on
	end

	test "should return null received_on when new" do
		package = create_package
		assert_nil package.received_on
	end

	test "should return valid date sent_on when in transit" do
		stub_package_for_in_transit()
		package = create_package
		package.update_status
		assert_not_nil package.sent_on
	end

	test "should return null received_on when in transit" do
		stub_package_for_in_transit()
		package = create_package
		package.update_status
		assert_nil package.received_on
	end

	test "should return valid date sent_on when delivered" do
		stub_package_for_successful_delivery()
		package = create_package
		package.update_status
		assert_not_nil package.sent_on
	end

	test "should return valid date received_on when delivered" do
		stub_package_for_successful_delivery()
		package = create_package
		package.update_status
		assert_not_nil package.received_on
	end

	test "should have many tracks" do
		package = create_package
		assert_equal 0, package.tracks.length
		Factory(:track, :trackable => package, 
			:time => Chronic.parse('yesterday') )
		assert_equal 1, package.reload.tracks.length
		Factory(:track, :trackable => package)
		assert_equal 2, package.reload.tracks.length
	end

end
