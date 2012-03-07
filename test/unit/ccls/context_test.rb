require 'test_helper'

class Ccls::ContextTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash

	assert_should_create_default_object
	assert_should_not_require_attributes( :position, :notes )
	assert_should_require_attribute_length( :notes, :maximum => 65000 )
	assert_should_act_as_list
	assert_should_have_many(:units)

	test "explicit Factory context test" do
		assert_difference('Context.count',1) {
			context = Factory(:context)
			assert_match /Key\d*/, context.key
			assert_match /Desc\d*/, context.description
		}
	end

	test "should return description as to_s" do
		context = create_context
		assert_equal context.description,
			"#{context}"
	end

	test "should have many context_data_sources" do
		context = Context[:addresses]
		assert !context.context_data_sources.empty?
		assert_difference('ContextDataSource.count',1) {
			context.data_sources << Factory(:data_source)
		}
	end

	test "should have many data_sources through context_data_sources" do
		context = Context[:addresses]
		assert !context.data_sources.empty?
	end

end
