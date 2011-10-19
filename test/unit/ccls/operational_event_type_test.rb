require 'test_helper'

class Ccls::OperationalEventTypeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:operational_events)
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position )	#, :project_id )
	assert_should_require_attribute_length( :code, :maximum => 250 )
	assert_should_require_attribute_length( :description,    :in => 4..250 )
	assert_should_require_attribute_length( :event_category, :in => 4..250 )

	test "should return event_category as to_s" do
		operational_event_type = create_operational_event_type
		assert_equal operational_event_type.event_category, "#{operational_event_type}"
	end

	test "should find by code with ['string']" do
		operational_event_type = OperationalEventType['ineligible']
		assert operational_event_type.is_a?(OperationalEventType)
	end

	test "should find by code with [:symbol]" do
		operational_event_type = OperationalEventType[:ineligible]
		assert operational_event_type.is_a?(OperationalEventType)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(OperationalEventType::NotFound) {
#			operational_event_type = OperationalEventType['idonotexist']
#		}
#	end

protected

	def create_operational_event_type(options={})
		operational_event_type = Factory.build(:operational_event_type,options)
		operational_event_type.save
		operational_event_type
	end

end
