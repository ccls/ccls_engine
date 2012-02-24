require 'test_helper'

class Ccls::TracingStatusTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:enrollments)
	assert_should_require_attributes( :code, :description )
	assert_should_require_unique_attributes( :code, :description )
	assert_should_not_require_attributes( :position )
	assert_should_require_attribute_length( :code, :description, :maximum => 250 )

	test "explicit Factory tracing_status test" do
		assert_difference('TracingStatus.count',1) {
			tracing_status = Factory(:tracing_status)
			assert_match /Code\d*/, tracing_status.code
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

	test "should find by code with ['string']" do
		tracing_status = TracingStatus['utl']
		assert tracing_status.is_a?(TracingStatus)
	end

	test "should find by code with [:symbol]" do
		tracing_status = TracingStatus[:utl]
		assert tracing_status.is_a?(TracingStatus)
	end

end
