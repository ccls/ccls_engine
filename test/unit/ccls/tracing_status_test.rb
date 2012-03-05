require 'test_helper'

class Ccls::TracingStatusTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:enrollments)
	assert_should_not_require_attributes( :position )

	test "explicit Factory tracing_status test" do
		assert_difference('TracingStatus.count',1) {
			tracing_status = Factory(:tracing_status)
			assert_match /Key\d*/, tracing_status.key
			assert_match /Desc\d*/, tracing_status.description
		}
	end

#	test "should return description as name" do
#		tracing_status = create_tracing_status
#		assert_equal tracing_status.description,
#			tracing_status.name
#	end

	test "should return description as to_s" do
		tracing_status = create_tracing_status
		assert_equal tracing_status.description,
			"#{tracing_status}"
	end

end
