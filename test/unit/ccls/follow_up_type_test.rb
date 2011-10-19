require 'test_helper'

class Ccls::FollowUpTypeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:follow_ups)
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position )
	assert_should_require_attribute_length( :code, :maximum => 250 )
	assert_should_require_attribute_length( :description,    :in => 4..250 )
#	assert_should_require_attribute_length( :event_category, :in => 4..250 )

	test "should return description as to_s" do
		follow_up_type = create_follow_up_type
		assert_equal follow_up_type.description, "#{follow_up_type}"
	end

	test "should find by code with ['string']" do
		create_follow_up_type(:code => 'justatest')
		follow_up_type = FollowUpType['justatest']
		assert follow_up_type.is_a?(FollowUpType)
	end

	test "should find by code with [:symbol]" do
		create_follow_up_type(:code => 'justatest')
		follow_up_type = FollowUpType[:justatest]
		assert follow_up_type.is_a?(FollowUpType)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(OperationalEventType::NotFound) {
#			follow_up_type = OperationalEventType['idonotexist']
#		}
#	end

protected

	def create_follow_up_type(options={})
		follow_up_type = Factory.build(:follow_up_type,options)
		follow_up_type.save
		follow_up_type
	end

end
