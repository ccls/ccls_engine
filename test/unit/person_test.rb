require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attribute( :last_name )
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :first_name )
	assert_should_not_require_attributes( :honorific )
	assert_should_not_require_attributes( :person_type_id )
	assert_should_act_as_list
	assert_should_have_many( :organizations )

#	TODO
#	assert_should_have_many( :interviews,
#		:foreign_key => :interviewer_id )

	with_options :maximum => 250 do |o|
		o.assert_should_require_attribute_length( :first_name )
		o.assert_should_require_attribute_length( :last_name )
		o.assert_should_require_attribute_length( :honorific )
	end

	test "should return full_name as to_s" do
		object = create_object
		assert_equal object.full_name, "#{object}"
	end

	test "should find random" do
		object = Person.random()
		assert object.is_a?(Person)
	end

	test "should return nil on random when no records" do
		Person.stubs(:count).returns(0)
		object = Person.random()
		assert_nil object
	end

end
