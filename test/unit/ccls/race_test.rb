require 'test_helper'

class Ccls::RaceTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
#	assert_should_have_many( :study_subjects )
	assert_should_require_attributes( :key, :code, :description )
	assert_should_require_unique_attributes( :key, :code, :description )
	assert_should_not_require_attributes( :position )
	assert_should_require_attribute_length( :description, :in => 4..250 )
	assert_should_require_attribute_length( :key, :code, :maximum => 250 )

	test "should return name as to_s" do
		object = create_object
		assert_equal object.name, "#{object}"
	end

	test "should find by key with ['string']" do
		object = Race['white']
		assert object.is_a?(Race)
	end

	test "should find by key with [:symbol]" do
		object = Race[:white]
		assert object.is_a?(Race)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(Race::NotFound) {
#			object = Race['idonotexist']
#		}
#	end

end
