require 'test_helper'

class Ccls::PersonTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attribute( :last_name )
	assert_should_not_require_attributes( 
		:position, 
		:first_name, 
		:honorific, 
		:organization_id, 
		:person_type_id )
	assert_should_act_as_list
	assert_should_have_many( :organizations )

#	TODO assert_should_have_many( :interviews, :foreign_key => :interviewer_id )

	assert_should_require_attribute_length( 
		:first_name, 
		:last_name, 
		:honorific, 
			:maximum => 250 )

	test "explicit Factory person test" do
		assert_difference('Person.count',1) {
			person = Factory(:person)
			assert_match /LastName\d*/, person.last_name
		}
	end

	test "should return full_name as to_s" do
		person = create_person
		assert_equal person.full_name, "#{person}"
	end

	test "should find random" do
		person = Person.random()
		assert person.is_a?(Person)
	end

	test "should return nil on random when no records" do
		Person.stubs(:count).returns(0)
		person = Person.random()
		assert_nil person
	end

#protected
#
#	def create_person(options={})
#		person = Factory.build(:person,options)
#		person.save
#		person
#	end

end
