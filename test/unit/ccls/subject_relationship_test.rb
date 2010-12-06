require File.dirname(__FILE__) + '/../test_helper'

class SubjectRelationshipTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_require_attributes( :code )
	assert_should_require_attributes( :description )
	assert_should_require_unique_attributes( :code )
	assert_should_require_unique_attributes( :description )
	assert_should_not_require_attributes( :position )
	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :description, :minimum => 4)
		o.assert_should_require_attribute_length( :code )
	end

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

	test "should find by code with ['string']" do
		object = SubjectRelationship['unknown']
		assert object.is_a?(SubjectRelationship)
	end

	test "should find by code with [:symbol]" do
		object = SubjectRelationship[:unknown]
		assert object.is_a?(SubjectRelationship)
	end

	test "should find random" do
		object = SubjectRelationship.random()
		assert object.is_a?(SubjectRelationship)
	end

	test "should return nil on random when no records" do
		SubjectRelationship.stubs(:count).returns(0)
		object = SubjectRelationship.random()
		assert_nil object
	end

end
