class ActiveSupport::TestCase

	def stub_package_for_in_transit(options={})
		stub_package_for_successful_event(:event => 'Departed')
		stub_package_tracking_info
	end

	def stub_package_for_successful_delivery(options={})
		stub_package_for_successful_event
		stub_package_tracking_info
	end

	def stub_package_for_failure(options={})
		ActiveMerchant::Shipping::FedEx.any_instance.stubs(
			:find_tracking_info).raises(
				ActiveMerchant::Shipping::ResponseError)
	end

protected

	def stub_package_for_successful_event(options={})
		shipment_event = shipment_event(options)
		ActiveMerchant::Shipping::TrackingResponse.any_instance.stubs(
			:shipment_events).returns([shipment_event])
		ActiveMerchant::Shipping::TrackingResponse.any_instance.stubs(
			:latest_event).returns(shipment_event)
	end

	def shipment_event(options={})
		ActiveMerchant::Shipping::ShipmentEvent.new(
			options[:event]||'Delivered',
			Time.now,
			ActiveMerchant::Shipping::Location.new({
				:city => 'BERKELEY',
				:state => 'CA',
				:zip => '94703'
			})
		)
	end

	def stub_package_tracking_info
		ActiveMerchant::Shipping::FedEx.any_instance.stubs(
			:find_tracking_info).returns(
				ActiveMerchant::Shipping::TrackingResponse.new(true ,'hello')
		)
	end

end
