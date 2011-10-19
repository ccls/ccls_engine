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
		interview_method = create_interview_method
		assert_equal interview_method.description, "#{interview_method}"
	end

	test "should find by code with ['string']" do
		interview_method = InterviewMethod['other']
		assert interview_method.is_a?(InterviewMethod)
	end

	test "should find by code with [:symbol]" do
		interview_method = InterviewMethod[:other]
		assert interview_method.is_a?(InterviewMethod)
	end

	test "should find random" do
		interview_method = InterviewMethod.random()
		assert interview_method.is_a?(InterviewMethod)
	end

	test "should return nil on random when no records" do
		InterviewMethod.stubs(:count).returns(0)
		interview_method = InterviewMethod.random()
		assert_nil interview_method
	end

protected

	def create_interview_method(options={})
		interview_method = Factory.build(:interview_method,options)
		interview_method.save
		interview_method
	end

end
