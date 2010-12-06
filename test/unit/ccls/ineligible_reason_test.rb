require File.dirname(__FILE__) + '/../test_helper'

class IneligibleReasonTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list

#	only if subject is ineligible
#	assert_should_have_many(:enrollments)

	assert_should_require_attributes( :code )
	assert_should_require_attributes( :description )
	assert_should_require_unique_attributes( :code )
	assert_should_require_unique_attributes( :description )
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :ineligible_context )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :code )
		o.assert_should_require_attribute_length( :description, :minimum => 4 )
		o.assert_should_require_attribute_length( :ineligible_context )
	end

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

	test "should find by code with ['string']" do
		object = IneligibleReason['moved']
		assert object.is_a?(IneligibleReason)
	end

	test "should find by code with [:symbol]" do
		object = IneligibleReason[:moved]
		assert object.is_a?(IneligibleReason)
	end

	test "should find random" do
		object = IneligibleReason.random()
		assert object.is_a?(IneligibleReason)
	end

	test "should return nil on random when no records" do
#		IneligibleReason.destroy_all
		IneligibleReason.stubs(:count).returns(0)
		object = IneligibleReason.random()
		assert_nil object
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(IneligibleReason::NotFound) {
#			object = IneligibleReason['idonotexist']
#		}
#	end

end
