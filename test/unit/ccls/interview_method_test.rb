require 'test_helper'

class Ccls::InterviewMethodTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :interviews, :instruments )
	assert_should_not_require_attributes( :position )

	test "explicit Factory interview_method test" do
		assert_difference('InterviewMethod.count',1) {
			interview_method = Factory(:interview_method)
			assert_match /Key\d*/, interview_method.key
			assert_match /Desc\d*/, interview_method.description
		}
	end

	test "should return description as to_s" do
		interview_method = create_interview_method
		assert_equal interview_method.description, "#{interview_method}"
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

#protected
#
#	def create_interview_method(options={})
#		interview_method = Factory.build(:interview_method,options)
#		interview_method.save
#		interview_method
#	end

end
