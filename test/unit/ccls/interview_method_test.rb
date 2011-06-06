require 'test_helper'

class Ccls::InterviewMethodTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :interviews, :instruments )
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position )
	assert_should_require_attribute_length( :code, :maximum => 250 )
	assert_should_require_attribute_length( :description, :in => 4..250 )

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

	test "should find by code with ['string']" do
		object = InterviewMethod['other']
		assert object.is_a?(InterviewMethod)
	end

	test "should find by code with [:symbol]" do
		object = InterviewMethod[:other]
		assert object.is_a?(InterviewMethod)
	end

	test "should find random" do
		object = InterviewMethod.random()
		assert object.is_a?(InterviewMethod)
	end

	test "should return nil on random when no records" do
		InterviewMethod.stubs(:count).returns(0)
		object = InterviewMethod.random()
		assert_nil object
	end

end
